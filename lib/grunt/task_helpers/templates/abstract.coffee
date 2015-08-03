_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'templates'

  enabled: -> _.isObject(@getAppConfig().templates)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().templates.basePath || super()

  getDestFile: ->
    File.join(@getDestPath(), @getAppConfig().templates.destFile)
