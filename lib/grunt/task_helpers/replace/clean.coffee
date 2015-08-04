_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('replace'))
    @fileCacheClean(@getCacheKey('replace-replace'))

    _.times _.size(@getAppConfig().replace), (n) =>
      @fileCacheClean(@getCacheKey("replace-replace-#{n}"))

