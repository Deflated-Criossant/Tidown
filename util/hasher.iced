fs = require 'fs'
checksum = require 'checksum'

file_hashes = {}

Hasher =
  initHashes: (@path, cb) ->
    if Object.keys(file_hashes).length is 0
      await fs.readdir @path, defer err, files
      for index, file of files
        filepath = "#{@path}\\#{file}"
        await @createHash filepath, defer sum
        @addHash sum, filepath
    cb()

  createHash: (filepath, cb) ->
    await checksum.file filepath, defer err, sum
    cb sum

  hasHash: (sum) ->
    file_hashes[sum]?

  getHash: (sum) ->
    if @hasHash sum
      file_hashes[sum]

  addHash: (sum, filepath) ->
    if not @hasHash sum
      file_hashes[sum] = filepath

module.exports = Hasher
