_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  run: ->
    _.each @getConfig().tasks.graspi_build, (task) =>
      @getTaskRunner().runGraspiTask @getEnvName(), @getModName(), task, false
