_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'webcomponents'

  enabled: -> _.isObject(@getAppConfig().webcomponents)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().webcomponents.basePath || super()

  getDestFile: ->
    File.join(@getDestPath(), @getAppConfig().webcomponents.destFile)
