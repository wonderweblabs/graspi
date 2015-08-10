_         = require 'lodash'
FCT       = require './class/file_change_tracker'

fcts          = {}
JsonFile      = null
FileChecksum  = null

module.exports = (grunt, cacheFile) ->
  unless _.isObject(JsonFile)
    JsonFile = require('./json_file')(grunt)

  unless _.isObject(FileChecksum)
    FileChecksum = require('./file_checksum')(grunt)

  unless _.isObject(fcts[cacheFile])
    fcts[cacheFile] = new FCT(JsonFile, FileChecksum, grunt, cacheFile)

  return fcts[cacheFile]