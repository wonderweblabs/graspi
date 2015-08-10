Cache = require('../../util/class/task_runner/cache')

module.exports = class TaskHelper extends require('./abstract')

  getCache: ->
    @_cache or= new Cache(@grunt)

  run: ->
    @getCache().setBuildCache(@getEmc())
