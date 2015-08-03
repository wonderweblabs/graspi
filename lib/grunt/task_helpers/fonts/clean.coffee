module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('fonts'))
    @fileCacheClean(@getCacheKey('fonts-copy'))
