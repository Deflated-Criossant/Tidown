sformat = require 'string-format'

class Metadata
  constructor: ->
    @fields = {}

  addField: (field, data) ->
    @fields[field] = data

  getField: (field) ->
    @fields[field]

  getFields: -> @fields

  mergeFields: (_fields) ->
    for attr of _fields
      @addField attr, _fields[attr]

  formatString: (string) ->
    try
      return sformat string, @fields
    catch err
      console.log "Invalid path format: #{err}"
      return null

module.exports = Metadata
