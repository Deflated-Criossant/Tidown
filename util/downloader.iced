config = require '../config'

queue = require 'queue'
q = queue({
  concurrency: config.limit
})

running = false

tracks = []

start = ->
  if not running
    running = true
    q.start (err) ->
      if err
        console.log err

q.on 'success', (result, job) ->
  if result.duplicate?
    console.log "Skipped duplicate - '#{result.duplicate}'!"
  else
    console.log "'#{result.getTitle()}' finished downloading (Quality: #{result.soundQuality})!"
  i = 0
  while i < tracks.length
    _track = tracks[i]
    if _track is result
      tracks.splice i, 1
      break
    i++

q.on 'error', (err, job) ->
  if err
    console.log err

q.on 'end', (err) ->
  if err
    console.log err

  running = false
  console.log 'Downloading finished. Exiting!'
  process.exit 1

Downloader =
  addDownload: (base, cb) ->
    tracks.push base
    q.push (cb) ->
      await base.download defer result
      cb null, result
    cb()

  startDownload: ->
    start()

  stopDownloads: (cb) ->
    q.end()
    await
      for track in tracks
        console.log 'Ayyy'
        await track.abort defer()
      defer()
    cb()

if process.platform is "win32"
  rl = require('readline').createInterface {
    input: process.stdin
    output: process.stdout
  }

  rl.on 'SIGINT', () ->
    process.emit 'SIGINT'

process.on 'SIGINT', () ->
  await Downloader.stopDownloads defer()
  process.exit()

module.exports = Downloader
