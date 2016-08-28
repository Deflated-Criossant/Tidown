Base = require './_base'

Track = require './track'

downloader = require '../util/downloader'

class Playlist extends Base
  init: (playlist) ->
    @id = playlist.uuid
    @title = playlist.title
    @creator = if playlist.creator.id isnt 0 and playlist.creator.name? then playlist.creator.name else 'Tidal'
    @duration = playlist.duration
    @trackAmount = playlist.numberOfTracks
    @coverID = playlist.image
    @coverSize = '1280x720' # TODO: Hit up the tidalapi dev on this
    @tracks = []
    @size = 0
    @maxSize = 0

    @getMetadata().addField 'playlist_id', @id
    @getMetadata().addField 'playlist_title', @fixInvalidCharsSlash(@title)
    @getMetadata().addField 'playlist_creator', @fixInvalidCharsSlash(@creator)

  updateTracks: (items) ->
    for item, index in items
      track = new Track item
      track.include = this
      track.coverID = @coverID
      track.coverSize = @coverSize
      track.mergeMetadata @getMetadata()
      track.getMetadata().addField 'track_number', index + 1 # Replacing the track_id with the actual number in the playlist
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
  getCreator: -> @creator
  getDuration: -> @duration
  getTrackAmount: -> @trackAmount
  getTracks: -> @tracks

module.exports = Playlist
