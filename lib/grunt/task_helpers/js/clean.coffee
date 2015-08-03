module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('js'))
    @fileCacheClean(@getCacheKey('js-copy'))
    @fileCacheClean(@getCacheKey('js-coffee_compile'))
    @fileCacheClean(@getCacheKey('js-concat'))
    @fileCacheClean(@getCacheKey('js-uglify'))
