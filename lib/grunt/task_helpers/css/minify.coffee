_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'cssmin'

  gruntTaskTargetAppendix: 'graspi-css-minify'

  cacheKeyAppendix: 'css-minify'

  cached: -> @getConfig().css.minify.cached == true

  isCacheValid: ->
    !@fileCacheHasChanged(@getDestFilePath())

  # ------------------------------------------------------------

  buildConfig: ->
    config = _.inject @getConfig().css.minify.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg                       = {}
    cfg.options               = config
    cfg.options.report                  = @getConfig().css.minify.report
    cfg.options.sourceMap               = @getConfig().css.minify.sourceMap

    cfg.files = {}
    cfg.files[@getDestFilePath()] = [@getDestFilePath()]

    @fileCacheUpdate(@getDestFilePath())

    cfg
