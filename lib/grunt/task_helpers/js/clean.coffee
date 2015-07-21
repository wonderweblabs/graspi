module.exports = class TaskHelper extends require('./abstract')

  getCacheKey: ->
    @_cacheKey

  run: ->
    @_cacheKey = "js-#{@eac.env_name}-#{@eac.app_name}"
    @fileCacheClean()
    @_cacheKey = "js-uglify-#{@eac.env_name}-#{@eac.app_name}"
    @fileCacheClean()

  isEnabled: ->
    true