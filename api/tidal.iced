config = require '../config'

TidalAPI = require 'tidalapi'
tidal = new TidalAPI
  username: config.username,
  password: config.password,
  token: config.token,
  quality: config.quality

module.exports = tidal
