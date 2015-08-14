module.exports = class TaskHelper extends require('./abstract')

  run: ->
    @getCache().setBuildCache(@getEmc(), @options.wrapping_task_name)
    @getCache().persist()
