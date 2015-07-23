_     = require('./lodash_extensions')
File  = require('path')

module.exports = (grunt, configFile) -> new GraspiTaskRunner(grunt, configFile)

class GraspiTaskRunner

  constructor: (grunt, configFile) ->
    @grunt      = grunt
    @configFile = configFile
    @config     = require('./config')(@grunt, @configFile)
    @eai        = require('../util/env_app_iterator')(@grunt, @config)

  getBaseConfig: ->
    @config.getBaseConfig()

  getC: ->
    @config

  getConfig: ->
    @config.getConfig()

  getAppConfig: (env_name, app_name) ->
    @config.getApp(env_name, app_name)

  getEai: ->
    @eai

  runGruntTask: (task, target1, target2) ->
    environment = @_selectEnvironment(target1, target2)
    app         = @_selectApp(target1, target2)

    cfg       = {}
    cfg[task] = {}

    task = [task]
    task.push environment unless _.isEmpty(environment)
    task.push app unless _.isEmpty(app)

    @grunt.config.merge cfg
    @grunt.task.run task.join(':')

  runGruntTasks: (tasks, target1, target2) ->
    _.each tasks, (task) => @runGruntTask(task, target1, target2)

  runGraspiTask: (target1, target2, helperPath) ->
    helperPath = File.join('..', helperPath)

    @eai.eachWithTargets target1, target2, (eac) =>
      taskHelper = new (require(helperPath))(@grunt, @config, eac)
      taskHelper.run()

  runDynamicTask: (task_name, t1, t2) ->
    env_name = @_selectEnvironment(t1, t2)
    app_name = @_selectApp(t1, t2)

    tasks = @getBaseConfig().tasks[task_name] || []

    if !_.isEmpty(env_name) && !_.isEmpty(app_name)
      tasks = @getAppConfig(env_name, app_name).tasks[task_name]
    else if !_.isEmpty(env_name)
      t = @getConfig()[env_name].tasks[task_name]
      tasks = t if t

    @runGruntTasks(tasks, t1, t2)


  # ----------------------------------------------------------
  # private

  # @nodoc
  _selectEnvironment: (target1, target2) ->
    environments = Object.keys(@config.getConfig())

    return target1 if _.includes environments, target1
    return target2 if _.includes environments, target2

    null

  # @nodoc
  _selectApp: (target1, target2) ->
    apps = Object.keys(@config.getAppConfigs())

    return target1 if _.includes apps, target1
    return target2 if _.includes apps, target2

    null