module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "browsersync-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getConfig().browserSync)

    @getConfig().browserSync.enabled == true