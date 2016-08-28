express = require 'express'
app = express()
http = require('http').Server app

config = require '../config'

app.get '/', (req, res) ->
  res.send 'Hello world!'

http.listen 3000, ->
  console.log "Listening on *:3000"
