_     = require('./lodash_extensions')
File  = require('path')

module.exports = (grunt) -> new GraspiTaskRunner(grunt)

class GraspiTaskRunner

  constructor: (grunt) ->
    @grunt  = grunt
    @eai    = require('../util/env_app_iterator')(grunt)

  runGruntTask: (configFile, task, target1, target2) ->
    config = require('./config')(@grunt, configFile)

    environment = @_selectEnvironment(config, target1, target2)
    app         = @_selectApp(config, target1, target2)

    cfg                  = {}
    cfg[task]            = {}
    cfg[task].options    = {}
    cfg[task].options.configFile = configFile

    task = [task]
    task.push environment unless _.isEmpty(environment)
    task.push app unless _.isEmpty(app)

    @grunt.config.merge cfg
    @grunt.task.run task.join(':')

  runGraspiTask: (configFile, target1, target2, helperPath) ->
    helperPath = File.join('..', helperPath)

    @eai.eachWithTargets configFile, target1, target2, (eac) =>
      taskHelper = new (require(helperPath))(@grunt, configFile, eac)
      taskHelper.run()


  # ----------------------------------------------------------
  # private

  # @nodoc
  _selectEnvironment: (config, target1, target2) ->
    environments = Object.keys(config.getConfig())

    return target1 if _.includes environments, target1
    return target2 if _.includes environments, target2

    null

  # @nodoc
  _selectApp: (config, target1, target2) ->
    apps = Object.keys(config.getAppConfigs())

    return target1 if _.includes apps, target1
    return target2 if _.includes apps, target2

    null