_     = require 'lodash'
Fs    = require 'fs'
File  = require 'path'
FCT   = require('../util/file_change_tracker')

#
# Getter:
# * isEnabled                   > true/false
# * isCached                    > true/false
# * isCacheValid                > true/false
# * getTaskRunner               > Task runner that executed this helper
# * getFileCache                > file_change_tracker
# * getConfig                   > @emc.emc
# * getAppConfig                > @emc.emc.options
# * getEnvName                  > @emc.env_name
# * getModName                  > @emc.mod_name
# * getTmpPath                  > tmp folder > default: tmpPath + env_name + mod_name
# * getDestPath                 > dest folder
# * getBasePath                 > src folder
# * getCacheKey                 > append with cacheKeyAppendix
# * getGruntTask                > grunt task
# * getGruntTaskTarget          > append with gruntTaskTargetAppendix
# * fileCacheHasChanged(file)   > true/false if isCached == true else always true
# * fileCacheUpdate(file)       > update entry
# * fileCacheClean              > clear for cache key
#
module.exports = class AbstractTaskHelper

  # If the task should run
  enabled: true

  # If the task should run under cache conditions
  cached: true

  # Appendix for cache key "#{@emc.env_name}-#{@emc.mod_name}"
  # e.g. "#{@emc.env_name}-#{@emc.mod_name}-test" would be configured
  # with cacheKeyAppendix: 'test'
  cacheKeyAppendix: null

  # The name of the grunt task to run.
  # E.g. gruntTask: 'copy'
  gruntTask: null

  # Appendix target for the grunt task. Normally it's just env + mod.
  # With this key, you can append e.g. to "development:base:xyz"
  # with gruntTaskTargetAppendix: "xyz"
  gruntTaskTargetAppendix: null


  # init
  constructor: (grunt, emc, taskRunner) ->
    @g            = grunt
    @emc          = emc
    @_taskRunner  = taskRunner
    @_fileCache   = FCT(@g, @getConfig().cacheFile, @getCacheKey())


  # whether run should return or execute
  isEnabled: ->
    _.result @, 'enabled'

  # whether the the call should be cached (check for file changes)
  isCached: ->
    _.result @, 'cached'

  # whether the cache is valid or not. If not, the run task
  # will go ahead with execution.
  isCacheValid: ->
    false


  # To execute tasks
  getTaskRunner: ->
    @_taskRunner

  # File cache instance
  getFileCache: ->
    @_fileCache

  # EMC
  getConfig: ->
    @emc.emc

  # EMC.options (app config)
  getAppConfig: ->
    @getConfig().options

  # Environment
  getEnvName: ->
    @emc.env_name

  # Module
  getModName: ->
    @emc.mod_name

  # App tmp path
  getTmpPath: ->
    File.join(@getConfig().tmpPath, @emc.env_name, @emc.mod_name)

  # Module destination path
  getDestPath: ->
    @getAppConfig().destPath

  # Module base src files path
  getBasePath: ->
    @getAppConfig().basePath

  # File caching sub hash name
  getCacheKey: (appendix = null) ->
    appendix or= @getCacheKeyAppendix()

    key = [@getEnvName(), @getModName()]
    key.push appendix if _.isString(appendix)

    key.join('-')

  # The appendix for the cache key
  getCacheKeyAppendix: ->
    _.result @, 'cacheKeyAppendix'

  # The grunt task to run
  getGruntTask: ->
    @g.fail.fatal 'Define a grunt task to run.' unless _.isString(_.result(@, 'gruntTask'))

    _.result(@, 'gruntTask')

  # Grunt target
  getGruntTaskTarget: ->
    key = [@getEnvName(), @getModName()]
    key.push @getGruntTaskTargetAppendix() if _.isString(@getGruntTaskTargetAppendix())

    key.join(':')

  # The appendix for the grunt task target
  getGruntTaskTargetAppendix: ->
    _.result @, 'gruntTaskTargetAppendix'


  # Check file for changes
  fileCacheHasChanged: (file) ->
    return true unless @isCached()

    @getFileCache().hasChanged(file, @getCacheKey())

  # Update file changes cache
  fileCacheUpdate: (file) ->
    @getFileCache().update(file, @getCacheKey())

    true

  # Clean up cache key
  fileCacheClean: (cacheKey = null) ->
    cacheKey or= @getCacheKey()

    @getFileCache().cleanAll(cacheKey)

  # Check if changed, if changed, automatically update. if changed result
  fileCacheUpdateIfChanged: (file) ->
    return @fileCacheUpdate(file) if @fileCacheHasChanged(file)

    false


  # called by runner
  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    target = @getGruntTaskTarget().replace(/(\.|\:)/g, '-')

    @g.config.set("#{@getGruntTask()}.#{target}", @buildConfig())
    @g.task.run "#{@getGruntTask()}:#{target}"

  # When extending: implement following.
  # Should return the config for the task configured
  # in gruntTask.
  buildConfig: ->
    @g.fail.fatal 'Implement buildConfig method.'
