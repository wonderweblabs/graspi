module.exports = class AbstractTaskHelper

  constructor: (grunt, config, eac) ->
    @_   = require('../util/lodash_extensions')
    @g   = grunt
    @c   = config
    @eac = eac

  buildConfig: ->
    @g.fail.fatal 'Implement buildConfig method.'

  run: ->
    return unless @isEnabled()

    @g.config.set("#{@getGruntTask()}.#{@getGruntTaskTarget()}", @buildConfig())
    @g.task.run "#{@getGruntTask()}:#{@getGruntTaskTarget()}"

  isEnabled: ->
    true

  getCacheKey: ->
    "#{@eac.env_name}-#{@eac.app_name}"

  getGruntTaskTarget: ->
    "#{@eac.env_name}-#{@eac.app_name}"

  getGruntTask: ->
    @g.fail.fatal 'Implement getGruntTask method.'

  getFileCache: ->
    @fileChangeTracker or= require('../util/file_change_tracker')(@g, @eac)

  getConfig: ->
    @eac.appConfig

  getAppConfig: ->
    @getConfig().config


  fileCacheHasChanged: (path) ->
    @getFileCache().hasChanged(path, @getCacheKey())

  fileCacheUpdate: (path) ->
    @getFileCache().update(path, @getCacheKey())

  fileCacheClean: ->
    @getFileCache().clean(@getCacheKey())
