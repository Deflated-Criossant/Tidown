fs = require 'fs'
ffm = require 'ffmetadata'
https = require 'https'
tidal = require '../api/tidal'

Tagger =
  writeTags: (track, cb) ->
    tags =
      title: track.getTitle()
      artist: track.getArtist()

    if track.getAlbumName()? and track.getAlbumName() isnt ''
      tags.album = track.getAlbumName()

    album = track.getAlbumOrPlaylist()
    if album? and album.constructor.name == 'Album'
      tags.track = track.trackNumber
      tags.date = album.date

    await fs.exists track.getCoverPath(), defer exists
    if exists
      await @doTagging track.getFilePath(), tags, defer()
      cb()
      return

    coverURL = @buildCoverURL track.coverID, track.coverSize
    coverFile = fs.createWriteStream track.getCoverPath()
    await https.get coverURL, defer coverRes
    coverRes.on 'error', (err) =>
      console.log err

    coverRes.pipe coverFile
    coverFile.on 'finish', () =>
      coverFile.close()

      await @doTagging track.getFilePath(), tags, defer()
      cb()

  buildCoverURL: (id, res) ->
    "https://resources.wimpmusic.com/images/#{id.replace(/-/g, '/')}/#{res}.jpg"

  doTagging: (path, tags, cb) ->
    ffm.write path, tags, (err) ->
      if err
        console.error err
      cb()

module.exports = Tagger
