module.exports = class TaskHelper extends require('./abstract')

  getCacheKey: ->
    @_cacheKey

  run: ->
    @_cacheKey = "css-#{@eac.env_name}-#{@eac.app_name}"
    @fileCacheClean()
    @_cacheKey = "css-minify-#{@eac.env_name}-#{@eac.app_name}"
    @fileCacheClean()

  isEnabled: ->
    true