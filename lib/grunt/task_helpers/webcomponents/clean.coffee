module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('webcomponents'))
    @fileCacheClean(@getCacheKey('webcomponents-copy'))
    @fileCacheClean(@getCacheKey('webcomponents-concat'))
    @fileCacheClean(@getCacheKey('webcomponents-coffee'))
    @fileCacheClean(@getCacheKey('webcomponents-copy'))
    @fileCacheClean(@getCacheKey('webcomponents-haml'))
    @fileCacheClean(@getCacheKey('webcomponents-haml-rename'))
    @fileCacheClean(@getCacheKey('webcomponents-sass'))
    @fileCacheClean(@getCacheKey('webcomponents-bower'))
    @fileCacheClean(@getCacheKey('webcomponents-bower-register'))
    @fileCacheClean(@getCacheKey('webcomponents-vulcanize'))
