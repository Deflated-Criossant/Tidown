fs = require 'fs-extra'
path = require 'path'
http = require 'http'

tidal = require '../api/tidal'
Base = require './_base'
config = require '../config'
Tagger = require '../util/tagger'
Hasher = require '../util/hasher'

class Track extends Base
  init: (track) ->
    @id = track.id
    @title = track.title
    if track.version? and track.version isnt ''
      @title = "#{@title} (#{track.version})"
    @artist = track.artist.name
    @trackNumber = track.trackNumber
    if track.album?
      @albumName = track.album.title
      @coverID = track.album.cover
      @coverSize = 1280

    @getMetadata().addField 'track_id', @id
    @getMetadata().addField 'track_title', @fixInvalidCharsSlash(@title)
    @getMetadata().addField 'track_artist', @fixInvalidCharsSlash(@artist)
    @getMetadata().addField 'track_number', @trackNumber
    if track.album?
      @getMetadata().addField 'track_album', @fixInvalidCharsSlash(@albumName)

    @updateFilePath()

  download: (cb) =>
    fs.mkdirs path.dirname(@getFilePath()), (err) ->
      if err
        console.log err

    await Hasher.initHashes path.dirname(@getFilePath()), defer()

    await tidal.getOfflineURL {id: @getID()}, defer data
    if data.subStatus is 2001 # "Resource not found"
      console.log 'Resource not found'
      cb this
      return
    if data.subStatus is 4005 # "Asset is not ready for playback"
      console.log 'Asset is not ready for playback'
      cb this
      return
    @offlineURL = data.url
    @soundQuality = data.soundQuality
    @updateFilePath() # Update again so the file-ending is properly set
    fs.exists @getFilePath(), (exists) =>
      if exists
        @duplicate = @getFilePath()
        cb this
        return

    @audioFile = fs.createWriteStream @getFilePath()

    await http.get @offlineURL, defer @audioRes
    @setMaxSize parseInt(@audioRes.headers['content-length'], 10)

    @audioRes.on 'error', (err) =>
      console.log err

    @getAlbumOrPlaylist()?.addMaxSize @size

    @setSize 0

    @audioRes.on 'data', (chunk) =>
      @addSize chunk.length
      @getAlbumOrPlaylist()?.addSize chunk.length

    @audioRes.pipe @audioFile
    @audioFile.on 'finish', () =>
      @audioFile.close()
      if not config.skipTagging
        await Tagger.writeTags this, defer()

      await Hasher.createHash @getFilePath(), defer sum
      if Hasher.hasHash sum
        @duplicate = Hasher.getHash sum
        await fs.unlink @getFilePath(), defer()
      else
        Hasher.addHash sum, @getFilePath()
      cb this

  abort: (cb) =>
    console.log 'Kappa'
    @audioRes?.destroy()
    @audioFile?.close()

    await fs.exists @getFilePath(), defer exists
    console.log 'MingLee'
    if exists
      await fs.unlink @getFilePath(), defer()
    cb()

  getID: -> @id
  getTitle: -> @title
  getArtist: -> @artist
  getTrackNumber: -> @trackNumber
  getAlbumName: -> @albumName

  updateFilePath: ->
    _path = path.normalize config.getPrependingPath()
    base = @getAlbumOrPlaylist()
    if base is undefined
      base = this
    _path = path.normalize "#{_path}#{@fixInvalidChars(@getMetadata().formatString(config.getFilePath(base)))}.#{if @soundQuality is 'LOSSLESS' then 'flac' else 'm4a'}"
    _path = _path.replace /\.\\/g, '\\'
    @path = _path

  getFilePath: -> @path
  getCoverPath: ->
    path.normalize "#{path.dirname(@path)}/cover.jpg"

  getAlbumOrPlaylist: -> @include

module.exports = Track
