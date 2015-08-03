module.exports = class TaskHelper extends require('./abstract')

  cacheKeyAppendix: 'images'

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('images'))
    @fileCacheClean(@getCacheKey('images-copy'))
    @fileCacheClean(@getCacheKey('images-imagemin'))
    @fileCacheClean(@getCacheKey('images-svgmin'))
