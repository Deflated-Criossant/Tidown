Base = require './_base'

Track = require './track'

downloader = require '../util/downloader'

class Album extends Base
  init: (album) ->
    @id = album.id
    @title = album.title
    @artist = album.artist.name
    @coverID = album.cover
    @date = album.releaseDate.substring(0, 4)
    @coverSize = '1280x1280'
    @tracks = []
    @size = 0
    @maxSize = 0

    @getMetadata().addField 'album_id', @id
    @getMetadata().addField 'album_title', @fixInvalidCharsSlash(@title)
    @getMetadata().addField 'album_artist', @fixInvalidCharsSlash(@artist)
    @getMetadata().addField 'album_date', @date

  updateTracks: (items) ->
    for item in items
      track = new Track item
      track.include = this
      track.coverID = @coverID
      track.coverSize = @coverSize
      track.mergeMetadata @getMetadata()
      track.getMetadata().addField 'track_album', @title # Replace track_album with actual album name it was found in
      track.updateFilePath()
      @tracks.push track

  download: (_) =>
    for track in @tracks
      await downloader.addDownload track, defer()
    downloader.startDownload()

  abort: (_) ->
    for track in @tracks
      await track.abort defer()

  getID: -> @id
  getTitle: -> @title
  getArtist: -> @artist
  getTracks: -> @tracks

module.exports = Album
