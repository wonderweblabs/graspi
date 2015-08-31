_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'webcomponents'

  enabled: -> @getConfig().webcomponent == true

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().basePath || super()
