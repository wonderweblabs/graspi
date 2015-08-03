File  = require 'path'
_     = require '../../lodash_extensions'
JF    = require '../../json_file'

mappingData = {}

module.exports = class Cache

  constructor: (grunt) ->
    @g        = grunt

  getTrackFile: ->
    @_jsonFile or= JF(@g)

  getBuildInfo: (emc) ->
    return { built: false, built_at: 0 } unless @g.file.exists(emc.emc.options.destPath)

    mapping = @_readTrackFile(emc)

    buildInfo = mapping["#{emc.env_name}-#{emc.mod_name}"]

    buildInfo || { built: false, built_at: 0 }

  setBuildCache: (emc) ->
    mapping = @_readTrackFile(emc)

    mapping["#{emc.env_name}-#{emc.mod_name}"] =
      built: true
      built_at: new Date().getTime()
      env_name: emc.env_name
      mod_name: emc.mod_name

    @_writeTrackFile(emc, mapping)

  clearBuildCache: (emc) ->
    @_writeTrackFile(emc, {})


  _readTrackFile: (emc) ->
    mappingData[emc.emc.modulesBuiltTrackFile] or= @getTrackFile().read(emc.emc.modulesBuiltTrackFile)
    mappingData[emc.emc.modulesBuiltTrackFile] or= {}

    mappingData[emc.emc.modulesBuiltTrackFile]

  _writeTrackFile: (emc, data) ->
    mappingData[emc.emc.modulesBuiltTrackFile] = data

    @getTrackFile().write(emc.emc.modulesBuiltTrackFile, data)