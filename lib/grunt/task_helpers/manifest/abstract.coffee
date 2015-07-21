module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "manifest-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getConfig().manifest)

    true

  getManifestFilePath: ->
    @getConfig().manifest.path

  getMappingFilePath: ->
    "#{@getConfig().tmp.filerevision}/#{@eac.env_name}-#{@eac.app_name}.json"