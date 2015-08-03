_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'filerev'

  enabled: -> _.isObject(@getConfig().postpipeline.filerevision)

  # ------------------------------------------------------------

  getMappingFile: ->
    File.join(@getTmpPath(), 'revision-mapping.json')