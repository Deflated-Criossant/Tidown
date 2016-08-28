tidal       = require './tidal'

Track       = require '../classes/track'
Album       = require '../classes/album'
Playlist    = require '../classes/playlist'

downloader  = require '../util/downloader'

API =
  addTrack: (id) ->
    await
      tidal.getTrackInfo {id: id}, defer info

    if info.subStatus?
      if info.subStatus is 2001
        console.log "Couldn't find track with ID #{id}!"
        process.exit 1

    track = new Track info
    await downloader.addDownload track, defer()
    downloader.startDownload()

  addAlbum: (id) ->
    await
      tidal.getAlbum {id: id}, defer info
      tidal.getAlbumTracks {id: id}, defer tracks

    if info.subStatus?
      if info.subStatus is 2001
        console.log "Couldn't find album with ID #{id}!"
        process.exit 1

    album = new Album info
    album.updateTracks tracks.items
    album.download()

  addPlaylist: (id) ->
    await
      tidal.getPlaylist {id: id}, defer info
      tidal.getPlaylistTracks {id: id}, defer tracks

    if info.subStatus?
      if info.subStatus is 2001
        console.log "Couldn't find playlist with ID #{id}!"
        process.exit 1

    playlist = new Playlist info
    playlist.updateTracks tracks.items
    playlist.download()

  getCoverArt: (id, res) ->
    tidal.getArtURL id, res

  getOfflineURL: (id, cb) ->
    await tidal.getOfflineURL {id: id}, defer data
    cb data

  searchTracks: (query) ->
    await tidal.search {
      query: query
      limit: limit or 999
      offset: offset or 0
      type: 'TRACKS'
    }, defer results
    results

  searchAlbums: (query) ->
    await tidal.search {
      query: query
      limit: limit or 999
      offset: offset or 0
      type: 'ALBUMS'
    }, defer results
    results

  searchPlaylists: (query) ->
    await tidal.search {
      query: query
      limit: limit or 999
      offset: offset or 0
      type: 'PLAYLISTS'
    }, defer results
    results

  searchArtists: (query) ->
    await tidal.search {query: query, type: 'ARTISTS'}, defer results
    results

  searchAll: (query, limit, offset) ->
    await tidal.search {
      query: query
      limit: limit or 999
      offset: offset or 0
    }, defer results
    results

module.exports = API
