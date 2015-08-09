_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'css'

  enabled: -> _.isObject(@getAppConfig().css)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().css.basePath || super() || []

  getDestFilePath: ->
    File.join(@getDestPath(), @getAppConfig().css.destFile)

  getDestFile: ->
    @getDestFilePath()