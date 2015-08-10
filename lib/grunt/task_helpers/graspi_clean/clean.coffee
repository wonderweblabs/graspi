_     = require 'lodash'
Cache = require('../../util/class/task_runner/cache')

module.exports = class TaskHelper extends require('./abstract')

  getCache: ->
    @_cache or= new Cache(@grunt)

  run: ->
    @getCache().clearBuildCache(@getEmc())

    _.each @getConfig().tasks.graspi_clean, (task) =>
      @getTaskRunner().runGraspiTask
        env_name: @getEnvName()
        mod_name: @getModName()
        task_name: task
        resolveDeps: false
