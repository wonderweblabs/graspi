module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "filerev-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getConfig().filerevision)

    true

  getMappingFilePath: ->
    "#{@getConfig().tmp.filerevision}/#{@eac.env_name}-#{@eac.app_name}.json"
