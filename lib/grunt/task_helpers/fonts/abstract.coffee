_ = require 'lodash'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'fonts'

  enabled: -> _.isObject(@getAppConfig().fonts)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().fonts.basePath || super() || []