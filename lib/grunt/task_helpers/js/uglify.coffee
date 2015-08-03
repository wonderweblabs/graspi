_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'uglify'

  gruntTaskTargetAppendix: 'graspi-js-uglify'

  cacheKeyAppendix: 'js-uglify'

  cached: -> @getConfig().js.uglify.cached == true

  isCacheValid: ->
    !@fileCacheHasChanged(@getDestFilePath())

  # ------------------------------------------------------------

  buildConfig: ->
    config = _.inject @getConfig().js.uglify.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg         = {}
    cfg.options = config
    cfg.files   = {}
    cfg.files[@getDestFilePath()] = [@getDestFilePath()]

    @fileCacheUpdate(@getDestFilePath())

    cfg