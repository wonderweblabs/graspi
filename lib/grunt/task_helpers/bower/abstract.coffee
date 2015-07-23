module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "bower-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    @eac.appConfig.bowerConcat.enabled == true

