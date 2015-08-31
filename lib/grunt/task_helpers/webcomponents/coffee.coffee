_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'coffee'

  gruntTaskTargetAppendix: 'graspi-webcomponents-coffee'

  cacheKeyAppendix: 'webcomponents-coffee'

  cached: true

  enabled: -> super() && _.size(@getFiles()) > 0

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= @grunt.file.expand({
      filter: 'isFile'
      cwd: @getBasePath()
    }, '**/*.coffee')

  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.bare      = true
    cfg.options.sourceMap = false
    cfg.files = [{
      expand: true
      cwd:    @getBasePath()
      dest:   @getDestPath()
      src:    @getFiles()
      ext:    '.js'
      filter: (file) =>
        destFile = file.replace(/\.coffee$/, '.js')
        destFile = destFile.replace(@getBasePath(), @getDestPath())
        return true unless @grunt.file.isFile(destFile)

        @fileCacheUpdateIfChanged(file)
    }]

    cfg
