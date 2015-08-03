module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('templates'))
    @fileCacheClean(@getCacheKey('templates-copy'))
    @fileCacheClean(@getCacheKey('templates-haml'))
    @fileCacheClean(@getCacheKey('templates-concat'))
