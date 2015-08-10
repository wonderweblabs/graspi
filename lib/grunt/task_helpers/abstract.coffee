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
# * getConfig                   > @getEmc().emc
# * getAppConfig                > @getEmc().emc.options
# * getEnvName                  > @options.env_name
# * getModName                  > @options.mod_name
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

  # Appendix for cache key "#{@options.env_name}-#{@options.mod_name}"
  # e.g. "#{@options.env_name}-#{@options.mod_name}-test" would be configured
  # with cacheKeyAppendix: 'test'
  cacheKeyAppendix: null

  # The name of the grunt task to run.
  # E.g. gruntTask: 'copy'
  gruntTask: null

  # Appendix target for the grunt task. Normally it's just env + mod.
  # With this key, you can append e.g. to "development:base:xyz"
  # with gruntTaskTargetAppendix: "xyz"
  gruntTaskTargetAppendix: null


  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * main_task_name
  # * resolveDeps [null/true/false]
  # * depsTask
  # * depsCaching [null/true/false]
  # * emc
  # * cached [true/false]
  #
  constructor: (@grunt, @options) ->

  # whether run should return or execute
  isEnabled: ->
    _.result @, 'enabled'

  # whether the the call should be cached (check for file changes)
  isCached: ->
    return false if @options.cached == false

    _.result @, 'cached'

  # whether the cache is valid or not. If not, the run task
  # will go ahead with execution.
  isCacheValid: ->
    false


  # To execute tasks
  getTaskRunner: ->
    @grunt.graspi.taskRunner

  # File cache instance
  getFileCache: ->
    @grunt.graspi.config.getFileCacheTracker(@getEmc())

  # EMC
  getEmc: ->
    @options.emc

  # EMC
  getConfig: ->
    @options.emc.emc

  # EMC.options (app config)
  getAppConfig: ->
    @getConfig().options

  # Environment
  getEnvName: ->
    @options.env_name

  # Module
  getModName: ->
    @options.mod_name

  # Task
  getTaskName: ->
    @options.task_name

  # App tmp path
  getTmpPath: ->
    File.join(@getConfig().tmpPath, @options.env_name, @options.mod_name)

  # Module destination path
  getDestPath: (emc = null) ->
    @grunt.graspi.config.getDestPath(emc || @getEmc())

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
    @grunt.fail.fatal 'Define a grunt task to run.' unless _.isString(_.result(@, 'gruntTask'))

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
  fileCacheHasChanged: (file, cacheKey = null) ->
    return true unless @isCached()

    cacheKey or= @getCacheKey()

    @getFileCache().hasChanged(file, cacheKey)

  # Update file changes cache
  fileCacheUpdate: (file, cacheKey = null) ->
    cacheKey or= @getCacheKey()

    @getFileCache().update(file, cacheKey)

    true

  # Clean up cache key
  fileCacheClean: (cacheKey = null) ->
    cacheKey or= @getCacheKey()

    @getFileCache().cleanAll(cacheKey)

  # Check if changed, if changed, automatically update. if changed result
  fileCacheUpdateIfChanged: (file, cacheKey = null) ->
    cacheKey or= @getCacheKey()

    if @fileCacheHasChanged(file, cacheKey)
      @fileCacheUpdate(file, cacheKey)
      true
    else
      false


  # called by runner
  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    target = @getGruntTaskTarget().replace(/(\.|\:)/g, '-')

    @grunt.config.set("#{@getGruntTask()}.#{target}", @buildConfig())
    @grunt.task.run "#{@getGruntTask()}:#{target}"

  # When extending: implement following.
  # Should return the config for the task configured
  # in gruntTask.
  buildConfig: ->
    @grunt.fail.fatal 'Implement buildConfig method.'
