module.exports = class TaskHelper extends require('./abstract')

  enabled: true

  # ------------------------------------------------------------

  run: ->
    @fileCacheClean(@getCacheKey('css'))
    @fileCacheClean(@getCacheKey('css-copy'))
    @fileCacheClean(@getCacheKey('css-sass'))
    @fileCacheClean(@getCacheKey('css-concat'))
    @fileCacheClean(@getCacheKey('css-minify'))
    @fileCacheClean(@getCacheKey('css-replace_urls'))
    @fileCacheClean(@getCacheKey('css-polymer_mixin_replace'))
