### Preparation phase ###

program = require 'commander'
config = require './config'

program
  .version('1.0.0')
  .option('-t, --type <type>', 'Type of download (Track / Album / Playlist)', /^(track|album|playlist)$/i)
  .option('-i, --id <id>', 'ID of the Track / Album / Playlist')
  .option('-q, --quality <quality>', 'Quality (Low / High / Lossless) [Lossless requires HiFi subscription!]', /^(low|high|lossless)$/i, 'HIGH')
  .option('-l, --limit <limit>', 'Amount of maximum parallel downloads', parseInt, 10)
  .option('-s, --skip', 'Skips tagging')
  .parse(process.argv)

if not program.type or not program.id
  program.outputHelp()
  return

if not /^(track|album|playlist)$/i.test(program.type)
  console.log 'Invalid type!'
  program.outputHelp()
  return

if not /^(low|high|lossless)$/i.test(program.quality)
  console.log 'Invalid quality!'
  program.outputHelp()
  return

config.quality = program.quality.toUpperCase()
config.limit = program.limit
config.skipTagging = program.skip or false

#########################

api = require './api/api'

switch program.type
  when 'track'
    api.addTrack program.id
  when 'album'
    api.addAlbum program.id
  when 'playlist'
    api.addPlaylist program.id
