_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'haml'

  gruntTaskTargetAppendix: 'graspi-webcomponents-haml'

  cacheKeyAppendix: 'webcomponents-haml'

  cached: true

  enabled: -> super() && _.size(@getFiles()) > 0

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= @grunt.file.expand({
      filter: 'isFile'
      cwd: @getBasePath()
    }, '**/*.haml')

  buildConfig: ->
    cfg                     = {}
    cfg.options             = {}
    cfg.options.language    = 'ruby'
    cfg.options.target      = 'html'
    cfg.options.placement   = 'global'
    cfg.options.bare        = true
    cfg.options.precompile  = false
    cfg.options.includePath = false
    cfg.files = [{
      expand: true
      cwd:    @getBasePath()
      dest:   @getDestPath()
      src:    @getFiles()
      ext:    '.html'
      filter: (file) =>
        destFile = file.replace(/\.haml$/, '.html')
        destFile = destFile.replace(@getBasePath(), @getDestPath())
        return true unless @grunt.file.isFile(destFile)

        @fileCacheUpdateIfChanged(file)
    }]

    cfg