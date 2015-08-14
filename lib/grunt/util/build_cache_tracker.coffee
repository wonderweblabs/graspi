_     = require 'lodash'
File  = require 'path'
JF    = require './json_file'
JC    = require './file_checksum'

module.exports = class Cache

  constructor: (@grunt, @file) ->
    @_mapping = @getTrackFile().read(@getFilePath()) || {}

  persist: ->
    @_writeTrackFile()

  getFilePath: ->
    @file

  getTrackFile: ->
    @_jsonFile or= new JF(@grunt)

  getDestPath: (emc) ->
    @grunt.graspi.config.getDestPath(emc)

  getBuildInfo: (emc, task_name) ->
    return { built: false, built_at: 0, task_name: null } unless _.isString(task_name)
    return { built: false, built_at: 0, task_name: task_name } unless _.isObject(emc)
    return { built: false, built_at: 0, task_name: task_name } unless _.isObject(emc.emc)
    return { built: false, built_at: 0, task_name: task_name } unless _.isObject(emc.emc.options)
    return { built: false, built_at: 0, task_name: task_name } unless @grunt.file.exists(@getDestPath(emc))

    mapping = @_mapping["#{emc.env_name}-#{emc.mod_name}"] || {}
    mapping = mapping[task_name] || {}

    checksum              = @_getTotalChecksum(emc)
    buildInfo             = _.clone(mapping)
    buildInfo.built       = buildInfo.checksum == checksum
    buildInfo.built_at  or= 0
    buildInfo.task_name or= task_name

    buildInfo || { built: false, built_at: 0 }

  setBuildCache: (emc, task_name) ->
    return unless _.isString(task_name)
    return unless _.isObject(emc)
    return unless _.isObject(emc.emc)
    return unless _.isObject(emc.emc.options)
    return unless @grunt.file.exists(@getDestPath(emc))

    checksum  = @_getTotalChecksum(emc)
    mapping   = @_mapping["#{emc.env_name}-#{emc.mod_name}"] || {}

    if _.isObject(mapping[task_name]) && mapping[task_name].checksum == checksum
      return mapping

    @_mapping["#{emc.env_name}-#{emc.mod_name}"] or= {}
    @_mapping["#{emc.env_name}-#{emc.mod_name}"][task_name] =
      checksum:   checksum
      built_at:   new Date().getTime()
      env_name:   emc.env_name
      mod_name:   emc.mod_name
      task_name:  task_name

  clearBuildCache: (emc) ->
    return unless _.isObject(emc)
    return unless _.isObject(emc.emc)
    return unless _.isObject(emc.emc.options)
    return unless @grunt.file.exists(@getDestPath(emc))

    delete @_mapping["#{emc.env_name}-#{emc.mod_name}"]


  # ----------------------------------------------------------
  # private

  # @nodoc
  _writeTrackFile: ->
    @getTrackFile().write(@getFilePath(), @_mapping)

  # @nodoc
  _getFileChecksum: ->
    @_fileChecksum or= new JC(@grunt)

  # @nodoc
  _getTotalChecksum: (emc) ->
    digest = _.map @_getFiles(emc), (file) => @_getFileChecksum().hexDigest(file)

    @_getFileChecksum().stringHexDigest(digest.join(''))

  # @nodoc
  _getFiles: (emc) ->
    basePath = emc.emc.options.basePath || ''

    _.inject emc.emc.options, [], (memo, opts, key) =>
      return memo unless _.isArray(opts.files)

      bp = opts.basePath || basePath

      _.each opts.files, (file) =>
        memo = memo.concat @grunt.file.expand({ filter: 'isFile' }, File.join(bp, file))

      memo
