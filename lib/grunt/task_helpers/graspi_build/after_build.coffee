module.exports = class TaskHelper extends require('./abstract')

  run: ->
    @getCache().setBuildCache(@getEmc())
