module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "watch-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getConfig().watch)

    @getConfig().watch.enabled == true