_                     = require 'lodash'
DependencyListBuilder = require('./task_runner/dependencies')
Runner                = require('./task_runner/runner')

module.exports = class TaskRunner

  constructor: (lodash, File, grunt, config, options) ->
    @_        = lodash
    @g        = grunt
    @File     = File
    @config   = config
    @options  = options

  getEmc: (env_name, mod_name) ->
    @config.getEmc(env_name, mod_name)

  getDefaultEnvName: ->
    @config.getDefaultEnvironment()

  getModuleNames: ->
    @config.getModuleNames()

  getEnvironmentNames: ->
    @config.getEnvironmentNames()

  getDependencyListBuilder: ->
    @_depListBuilder or= new DependencyListBuilder(@_, @g, @config)

  getRunner: ->
    @_runner or= new Runner(@_, @g, @config, @)


  #
  # run graspi task
  #

  runGraspiTask: (env_name, mod_name, task_name = null, dependencyResolving = false, defaultTaskName = null, caching = true) ->
    if dependencyResolving == true
      @runGraspiTaskWithDeps(env_name, mod_name, task_name, defaultTaskName, caching)
    else
      @runGraspiTaskWithoutDeps(env_name, mod_name, task_name)

  runGraspiTaskWithDeps: (env_name, mod_name, task_name = null, defaultTaskName = null, caching = true) ->
    [env_name, mod_name, task_name] = @_normalizeTaskParams(env_name, mod_name, task_name)

    runList = @getDependencyListBuilder().buildExecutionList(env_name, mod_name, task_name, defaultTaskName, caching)
    @getRunner().runTasks(runList)

  runGraspiTaskWithoutDeps: (env_name, mod_name, task_name = null) ->
    [env_name, mod_name, task_name] = @_normalizeTaskParams(env_name, mod_name, task_name)

    @getRunner().runGruntTask(env_name, mod_name, task_name)


  #
  # run dynamic graspi task
  #

  runDynamicGraspiTask: (env_name, mod_name, task_name = null, dependencyResolving = false, defaultTaskName = null, caching = true) ->
    if dependencyResolving == true
      @runDynamicGraspiTaskWithDeps(env_name, mod_name, task_name, defaultTaskName, caching)
    else
      @runDynamicGraspiTaskWithoutDeps(env_name, mod_name, task_name)

  runDynamicGraspiTaskWithDeps: (env_name, mod_name, task_name = null, defaultTaskName = null, caching = true) ->
    [env_name, mod_name, task_name] = @_normalizeTaskParams(env_name, mod_name, task_name)

    runList = @getDependencyListBuilder().buildExecutionList(env_name, mod_name, task_name, defaultTaskName, caching)

    runList = _.filter runList, (runListEntry) ->
      runListEntry.env_name != env_name &&
      runListEntry.mod_name != mod_name &&
      runListEntry.task_name != task_name

    @getRunner().runTasks(runList)
    @getRunner().runDynamicTask(env_name, mod_name, task_name)

  runDynamicGraspiTaskWithoutDeps: (env_name, mod_name, task_name = null) ->
    [env_name, mod_name, task_name] = @_normalizeTaskParams(env_name, mod_name, task_name)

    @getRunner().runDynamicTask(env_name, mod_name, task_name)


  #
  # run task helper
  #

  runGraspiTaskHelper: (environment, module, helperPath) ->
    helperPath = @_resolveHelperPath(helperPath)

    taskHelper = new (require(helperPath))(@g, @getEmc(environment, module), @)
    taskHelper.run()

  # ----------------------------------------------------------
  # private

  # @nodoc
  _normalizeTaskParams: (env_name, mod_name, task_name = null) ->
    if !@_.isString(env_name) || !@_.isString(mod_name)
      @g.fail.fatal('Graspi needs at least a module and a task to run.')

    if !@_.isString(task_name) || task_name.length <= 0
      task_name = mod_name
      mod_name  = env_name
      env_name  = @getDefaultEnvName()

    if !@_.includes(@getEnvironmentNames(), env_name)
      @g.fail.fatal("Graspi: unknown environment - #{env_name}")

    if !@_.includes(@getModuleNames(), mod_name)
      @g.fail.fatal("Graspi: unknown module - #{mod_name}")

    [env_name, mod_name, task_name]

  # @nodoc
  _resolveHelperPath: (helperPath) ->
    loadPaths = (@options.tasksLoadPaths || [])

    @_.inject loadPaths, null, (memo, loadPath) =>
      if memo == null && @g.file.exists(@File.join(loadPath, "#{helperPath}.coffee"))
        memo = @File.join(loadPath, helperPath)
      else if memo == null && @g.file.exists(@File.join(loadPath, "#{helperPath}.js"))
        memo = @File.join(loadPath, helperPath)

      memo

