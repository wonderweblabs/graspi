module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('webcomponents'))
    @fileCacheClean(@getCacheKey('webcomponents-copy'))
    @fileCacheClean(@getCacheKey('webcomponents-concat'))
