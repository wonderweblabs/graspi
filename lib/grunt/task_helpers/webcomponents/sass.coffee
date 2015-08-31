_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'sass'

  gruntTaskTargetAppendix: 'graspi-webcomponents-sass'

  cacheKeyAppendix: 'webcomponents-sass'

  cached: true

  enabled: -> super() && _.size(@getFiles()) > 0

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= @grunt.file.expand({
      filter: 'isFile'
      cwd: @getBasePath()
    }, '**/*.{sass,scss}')

  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.sourcemap = 'none'
    cfg.options.precision = 10
    cfg.options.loadPath  = @getLoadPaths()
    cfg.options.update    = true
    cfg.files = [{
      expand: true
      cwd:    @getBasePath()
      dest:   @getDestPath()
      src:    @getFiles()
      ext:    '.css'
      filter: (file) =>
        destFile = file.replace(/\.(sass|scss)$/, '.css')
        destFile = destFile.replace(@getBasePath(), @getDestPath())
        return true unless @grunt.file.isFile(destFile)

        @fileCacheUpdateIfChanged(file)
    }]

    cfg

  getLoadPaths: ->
    @getConfigLoadPaths().concat([@getBasePath()])

  getConfigLoadPaths: ->
    return [] unless _.isObject(@getConfig().css)
    return [] unless _.isObject(@getConfig().css.sass)
    return [] unless _.isObject(@getConfig().css.sass.options)
    return [] unless _.isArray(@getConfig().css.sass.options.loadPath)

    @getConfig().css.sass.options.loadPath
