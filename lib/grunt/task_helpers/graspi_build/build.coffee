_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  run: ->
    _.each @getConfig().tasks.graspi_build, (task) =>
      @getTaskRunner().runGraspiTask
        env_name: @getEnvName()
        mod_name: @getModName()
        task_name: task
        resolveDeps: false
