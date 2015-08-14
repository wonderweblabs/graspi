_ = require 'lodash'

module.exports = class Task

  constructor: (@grunt, @emc, @task_name) ->
    @original_task_name = @task_name.replace(/^graspi\_/, '')
    @task_name = "graspi_#{@original_task_name}"

  getTaskName: ->
    @task_name

  getOriginalTaskName: ->
    @original_task_name

  getEmc: ->
    @emc

  resolve: ->
    return [] unless _.isObject(@emc)
    return [] unless _.isObject(@emc.emc)
    return [] unless _.isObject(@emc.emc.tasks)
    return [@getTaskName()] unless _.isArray(@emc.emc.tasks[@getTaskName()])

    _.inject @emc.emc.tasks[@getTaskName()], [], (memo, task_name) =>
      memo.concat((new Task(@grunt, @getEmc(), task_name)).resolve())
