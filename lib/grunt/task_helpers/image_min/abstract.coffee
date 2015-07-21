module.exports = class AbstractTaskHelper extends require('../abstract')

  getCacheKey: ->
    "image_min-#{@eac.env_name}-#{@eac.app_name}"

  getDestFullPath: ->
    "#{@getAppConfig().images.destPath}/#{@getAppConfig().images.destFolder}"

