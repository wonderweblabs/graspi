_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'manifest'

  enabled: -> _.isObject(@getConfig().postpipeline.manifest)

  # ------------------------------------------------------------

  getManifestFile: ->
    @getConfig().postpipeline.manifest.options.path

  getMappingFile: ->
    File.join(@getTmpPath(), 'revision-mapping.json')
