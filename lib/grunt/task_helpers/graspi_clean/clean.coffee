_     = require 'lodash'
Cache = require('../../util/class/task_runner/cache')

module.exports = class TaskHelper extends require('./abstract')

  getCache: ->
    @_cache or= new Cache(@g)

  run: ->
    @getCache().clearBuildCache(@emc)
