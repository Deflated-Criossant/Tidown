Metadata = require '../util/metadata'

class Base
  constructor: (@object) ->
    @metadata = new Metadata
    @init @object

  init: (object) ->
  mergeMetadata: (metadata) ->
    @getMetadata().mergeFields metadata.getFields()

  download: (cb) ->
  abort: (cb) ->

  setSize: (amount) -> @size = amount
  addSize: (amount) -> @size += amount
  getSize: -> @size

  setMaxSize: (amount) -> @maxSize = amount
  addMaxSize: (amount) -> @maxSize += amount
  getMaxSize: -> @maxSize

  getMetadata: -> @metadata
  getProgress: -> (@size / @maxSize * 100).toFixed(2)
  getCoverID: -> @coverID
  getCoverSize: -> @coverSize

  fixInvalidChars: (string) ->
    string.replace /[:\*\?"<>\|]/g, ''

  fixInvalidCharsSlash: (string) ->
    string.replace /[:\/\*\?"<>\|]/g, ''

module.exports = Base
