module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "css-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().css)

    true

  getDestFilePath: ->
    "#{@getAppConfig().css.destPath}/#{@getAppConfig().css.destFile}"