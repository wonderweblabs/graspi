fs        = require 'fs'
path      = require 'path'
_         = require './lodash_extensions'
FCT       = require './class/file_change_tracker'

fcts          = {}
JsonFile      = null
FileChecksum  = null

module.exports = (grunt, cacheFile, defaultScope = null) ->
  unless _.isObject(JsonFile)
    JsonFile = require('./json_file')(grunt)

  unless _.isObject(FileChecksum)
    FileChecksum = require('./file_checksum')(grunt)

  unless _.isObject(fcts[cacheFile])
    fcts[cacheFile] = new FCT(_, fs, path, JsonFile, FileChecksum, grunt, cacheFile, defaultScope)

  return fcts[cacheFile]