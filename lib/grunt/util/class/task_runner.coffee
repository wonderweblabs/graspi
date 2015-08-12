_                     = require 'lodash'
File                  = require 'path'
DependencyListBuilder = require('./task_runner/dependencies')
Runner                = require('./task_runner/runner')

module.exports = class TaskRunner

  constructor: (@grunt) ->

  getConfig: ->
    @grunt.graspi.config

  getEmc: (env_name, mod_name) ->
    @getConfig().getEmc(env_name, mod_name)

  getModuleNames: ->
    @getConfig().getModuleNames()

  getEnvironmentNames: ->
    @getConfig().getEnvironmentNames()

  getDependencyListBuilder: ->
    new DependencyListBuilder(@grunt)

  getRunner: ->
    @_runner or= new Runner(@grunt, @)

  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * main_task_name
  # * resolveDeps [null/true/false]
  # * depsTask
  # * depsCaching [null/true/false]
  #
  runGraspiTask: (options = {}) ->
    unless _.isString(options.env_name)
      @grunt.fail.fatal('options.env_name missing.')

    unless _.isString(options.mod_name)
      @grunt.fail.fatal('options.mod_name missing.')

    unless _.isString(options.task_name)
      @grunt.fail.fatal('options.task_name missing.')

    @_appendOptions(options)

    if _.isEmpty(options.main_task_name)
      options.main_task_name = options.task_name

    if options.resolveDeps == true
      runList = @getDependencyListBuilder().buildExecutionList(options)

      @getRunner().runTasks(runList)
    else
      @getRunner().runGruntTask(options)

  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * main_task_name
  # * resolveDeps [null/true/false]
  # * depsTask
  # * depsCaching [null/true/false]
  #
  runDynamicGraspiTask: (options = {}) ->
    unless _.isString(options.env_name)
      @grunt.fail.fatal('options.env_name missing.')

    unless _.isString(options.mod_name)
      @grunt.fail.fatal('options.mod_name missing.')

    unless _.isString(options.task_name)
      @grunt.fail.fatal('options.task_name missing.')

    @_appendOptions(options)

    if _.isEmpty(options.main_task_name)
      options.main_task_name = options.task_name

    if options.resolveDeps == true
      runList = @getDependencyListBuilder().buildExecutionList(options)

    runList or= []
    runList = _.filter runList, (runListEntry) => runListEntry.mod_name != options.mod_name

    _.each (options.emc.emc.tasks[options.task_name] || []), (task_name) =>
      runList.push
        env_name:       options.env_name
        mod_name:       options.mod_name
        task_name:      task_name
        main_task_name: task_name
        resolveDeps:    options.resolveDeps
        depsTask:       options.depsTask
        depsCaching:    options.depsCaching

    @getRunner().runTasks(runList)

  #
  # run task helper
  #
  runGraspiTaskHelper: (env_name, mod_name, helperPath) ->
    helperPath = @_resolveHelperPath(helperPath)

    options = @_appendOptions({ env_name: env_name, mod_name: mod_name })

    taskHelper = new (require(helperPath))(@grunt, options)
    taskHelper.run()

  # ----------------------------------------------------------
  # private

  # @nodoc
  _resolveHelperPath: (helperPath) ->
    loadPaths = (@grunt.option('taskHelperLoadPaths') || [])

    _.inject loadPaths, null, (memo, loadPath) =>
      if memo == null && @grunt.file.exists(File.join(loadPath, "#{helperPath}.coffee"))
        memo = File.join(loadPath, helperPath)
      else if memo == null && @grunt.file.exists(File.join(loadPath, "#{helperPath}.js"))
        memo = File.join(loadPath, helperPath)

      memo

  # @nodoc
  _appendOptions: (options) ->
    mod_name = options.mod_name

    options.env_name or=        @grunt.option "#{mod_name}_env_name"
    options.mod_name or=        @grunt.option "#{mod_name}_mod_name"
    options.task_name or=       @grunt.option "#{mod_name}_task_name"
    options.main_task_name or=  @grunt.option "#{mod_name}_main_task_name"
    options.depsTask or=        @grunt.option "#{mod_name}_depsTask"
    options.emc or=             @grunt.option "#{mod_name}_emc"
    options.emc or=             @getEmc(options.env_name, options.mod_name)

    unless _.isBoolean(options.resolveDeps)
      options.resolveDeps = @grunt.option "#{mod_name}_resolveDeps"

    unless _.isBoolean(options.depsCaching)
      options.depsCaching or= @grunt.option "#{mod_name}_depsCaching"

    unless _.isBoolean(options.cached)
      options.cached or= @grunt.option "#{mod_name}_cached"

    @grunt.option "#{mod_name}_env_name",       options.env_name
    @grunt.option "#{mod_name}_mod_name",       options.mod_name
    @grunt.option "#{mod_name}_task_name",      options.task_name
    @grunt.option "#{mod_name}_main_task_name", options.main_task_name
    @grunt.option "#{mod_name}_resolveDeps",    options.resolveDeps
    @grunt.option "#{mod_name}_depsTask",       options.depsTask
    @grunt.option "#{mod_name}_depsCaching",    options.depsCaching
    @grunt.option "#{mod_name}_cached",         options.cached
    @grunt.option "#{mod_name}_emc",            options.emc

    options

