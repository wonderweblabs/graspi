_ = require 'lodash'

module.exports = class Runner

  constructor: (lodash, grunt, config, taskRunner) ->
    @_          = lodash
    @g          = grunt
    @config     = config
    @taskRunner = taskRunner

  getEmc: (env_name, mod_name) ->
    @config.getEmc(env_name, mod_name)

  runTasks: (runList) ->
    @_.each runList, (runListEntry) =>
      @runGruntTask(
        runListEntry.env_name,
        runListEntry.mod_name,
        runListEntry.task_name
      )

  runDynamicTask: (env_name, mod_name, task_name) ->
    emc = @getEmc(env_name, mod_name)
    taskList = emc.emc.tasks[task_name]

    _.each taskList, (tn) =>
      @runGruntTask(env_name, mod_name, tn)

  runGruntTask: (env_name, mod_name, task_name) ->
    task_name = task_name.replace(/^graspi\_/, '')

    cfg             = {}
    cfg[task_name]  = {}

    @g.config.merge cfg
    @g.task.run "graspi_#{task_name}:#{env_name}:#{mod_name}"

