_                     = require 'lodash'
File                  = require 'path'

taskRunner = null

module.exports = (grunt) -> taskRunner or= new TaskRunner(grunt)

class TaskRunner

  constructor: (@grunt) ->

  getConfig: ->
    @grunt.graspi.config

  getEmc: (env_name, mod_name) ->
    @getConfig().getEmc(env_name, mod_name)

  getModuleNames: ->
    @getConfig().getModuleNames()

  getEnvironmentNames: ->
    @getConfig().getEnvironmentNames()


  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * cached
  # * resolveDeps [true/false]
  # * depsTask
  #
  runGraspiTask: (options = {}) ->
    unless _.isString(options.env_name)
      @grunt.fail.fatal('options.env_name missing.')

    unless _.isString(options.mod_name)
      @grunt.fail.fatal('options.mod_name missing.')

    unless _.isString(options.task_name)
      @grunt.fail.fatal('options.task_name missing.')

    options.depsTask or= options.task_name

    module      = @getConfig().getModule(options.env_name, options.mod_name)
    depModules  = if options.resolveDeps == true then module.resolveDependencyTree() else [module]
    depModules  = @_filterCachedModules(depModules, module, options)
    tasksList   = @_buildTasks(depModules, module, options)

    @_runTaskList(module, tasksList, options)

  #
  # run task helper
  #
  runGraspiTaskHelper: (env_name, mod_name, helperPath, options = {}) ->
    helperPath = @_resolveHelperPath(helperPath)

    options.env_name = env_name
    options.mod_name = mod_name
    options = @_appendOptions(options)

    module  = @getConfig().getModule(env_name, mod_name)

    taskHelper = new (require(helperPath))(@grunt, module, options)
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
    options.depsTask or=        @grunt.option "#{mod_name}_depsTask"
    options.emc or=             @grunt.option "#{mod_name}_emc"
    options.emc or=             @getEmc(options.env_name, options.mod_name)
    options.wrapping_task_name or=  @grunt.option "#{mod_name}_wrapping_task_name"

    unless _.isBoolean(options.resolveDeps)
      options.resolveDeps = @grunt.option "#{mod_name}_resolveDeps"

    unless _.isBoolean(options.depsCaching)
      options.depsCaching or= @grunt.option "#{mod_name}_depsCaching"

    unless _.isBoolean(options.cached)
      options.cached or= @grunt.option "#{mod_name}_cached"

    @grunt.option "#{mod_name}_env_name",       options.env_name
    @grunt.option "#{mod_name}_mod_name",       options.mod_name
    @grunt.option "#{mod_name}_task_name",      options.task_name
    @grunt.option "#{mod_name}_resolveDeps",    options.resolveDeps
    @grunt.option "#{mod_name}_depsTask",       options.depsTask
    @grunt.option "#{mod_name}_depsCaching",    options.depsCaching
    @grunt.option "#{mod_name}_cached",         options.cached
    @grunt.option "#{mod_name}_emc",            options.emc
    @grunt.option "#{mod_name}_wrapping_task_name", options.wrapping_task_name

    options

  # @nodoc
  _filterCachedModules: (depModules, mainModule, options) ->
    forceBuildModules = @getConfig().getUserConfig().getForceBuildModules()

    _.inject depModules, [], (memo, module) =>
      return memo.concat([module]) if module.getEMName() == mainModule.getEMName()
      return memo.concat([module]) if module.isBuilt(options.depsTask) == false
      return memo.concat([module]) if _.includes(forceBuildModules, module.getModName())

      memo

  # @nodoc
  _buildTasks: (depModules, mainModule, options) ->
    _.inject depModules, [], (memo, module) =>
      if module.getEMName() == mainModule.getEMName()
        task_name = options.task_name
      else
        task_name = options.depsTask

      memo.push
        env_name:   module.getEnvName()
        mod_name:   module.getModName()
        task_name:  'build_before_each'
        appendix:   task_name

      _.each module.getTaskList(task_name), (tn) =>
        memo.push
          env_name:   module.getEnvName()
          mod_name:   module.getModName()
          task_name:  tn.replace(/^graspi\_/, '')

      memo.push
        env_name:   module.getEnvName()
        mod_name:   module.getModName()
        task_name:  'build_after_each'
        appendix:   task_name

      memo

  # @nodoc
  _runTaskList: (mainModule, tasksList, options) ->
    @grunt.task.run "graspi_build_before:#{mainModule.getEnvName()}:#{mainModule.getModName()}:#{options.task_name}"

    _.each tasksList, (task) =>
      task.task_name = "graspi_#{task.task_name}"
      t = [task.task_name, task.env_name, task.mod_name]
      t.push task.appendix if _.isString(task.appendix)

      cfg                       = {}
      cfg["#{task.task_name}"]  = {}

      @grunt.config.merge(cfg)
      @grunt.task.run t.join(':')

    @grunt.task.run "graspi_build_after:#{mainModule.getEnvName()}:#{mainModule.getModName()}:#{options.task_name}"

