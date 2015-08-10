_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'copy'

  gruntTaskTargetAppendix: 'graspi-css-copy'

  cacheKeyAppendix: 'css-copy'

  cached: -> @getConfig().css.copy.cached == true

  enabled: -> super() && _.size(@getCssFiles()) > 0

  isCacheValid: ->
    _.inject @getCssFiles(), true, (memo, file) =>
      return false if memo == false

      file = File.join(@getBasePath(), file)
      return !@fileCacheHasChanged(file) if @grunt.file.isFile(file)

      _.inject @grunt.file.expand(file), true, (subMemo, subFile) =>
        if subMemo == false then false else !@fileCacheHasChanged(subFile)

  # ------------------------------------------------------------

  getCssFiles: ->
    @_cssFiles or= _.inject (@getAppConfig().css.files || []), [], (memo, file) =>
      memo.push file if /\.css$/.test(file)
      memo

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = [{
      expand: true
      ext:    '.css'
      src:    @getCssFiles()
      cwd:    File.join(@getBasePath(), '/')
      dest:   File.join(@getTmpPath(), '/')
      filter: (file) => @fileCacheUpdateIfChanged(file)
    }]

    cfg