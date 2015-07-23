module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "js-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().js)

    true

  getDestFilePath: ->
    "#{@getAppConfig().js.destPath}/#{@getAppConfig().js.destFile}"