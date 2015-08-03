fs            = require 'fs'
crypto        = require 'crypto'
_             = require './lodash_extensions'
FileChecksum  = require './class/file_checksum'

fc = null

module.exports = (grunt) ->
  fc = new FileChecksum(fs, crypto, grunt) unless _.isObject(fc)

  return fc