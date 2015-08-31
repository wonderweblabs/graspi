_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'copy'

  gruntTaskTargetAppendix: 'graspi-webcomponents-copy'

  cacheKeyAppendix: 'webcomponents-copy'

  cached: true

  enabled: -> super() && _.size(@getFiles()) > 0

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= @grunt.file.expand({
      filter: (file) =>
        return false if /\.(coffee|sass|scss|haml)$/.test(file)
        @grunt.file.exists(file) && @grunt.file.isFile(file)
      cwd: @getBasePath()
    }, '**/*')

  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.files = [{
      expand: true
      cwd:    @getBasePath()
      dest:   @getDestPath()
      src:    @getFiles()
      filter: (file) =>
        destFile = file.replace(@getBasePath(), @getDestPath())
        return true unless @grunt.file.isFile(destFile)

        @fileCacheUpdateIfChanged(file)
    }]

    cfg