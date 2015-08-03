_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'js'

  enabled: -> _.isObject(@getAppConfig().js)

  # ------------------------------------------------------------

  getBasePath: ->
    @getAppConfig().js.basePath || super()

  getDestFilePath: ->
    File.join(@getDestPath(), @getAppConfig().js.destFile)
