_ = require 'lodash'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'images'

  enabled: -> _.isObject(@getAppConfig().images)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().images.basePath || super() || []

