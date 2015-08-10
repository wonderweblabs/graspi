_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'copy'

  gruntTaskTargetAppendix: 'graspi-templates-copy'

  cacheKeyAppendix: 'templates-copy'

  cached: -> @getConfig().templates.copy.cached == true

  enabled: ->
    super() &&
    _.isArray(@getAppConfig().templates.files) &&
    _.size(@getAppConfig().templates.files) > 0 &&
    _.size(@getFiles()) > 0

  isCacheValid: ->
    _.inject @getFilesExpanded(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= _.inject (@getAppConfig().templates.files || []), [], (memo, file) =>
      memo.push file if /\.html$/.test(file)
      memo

  getFilesExpanded: ->
    _.inject @getFiles(), [], (memo, file) =>
      file = File.join(@getBasePath(), file)

      unless @grunt.file.isFile(file)
        return memo.concat(@grunt.file.expand({ filter: 'isFile' }, file))

      memo.push file
      memo

  buildConfig: ->
    cfg                         = {}
    cfg.options                 = {}
    cfg.options.sourcesContent  = false
    cfg.files                   = [{
      expand: true
      ext:    '.html'
      src:    @getFiles()
      cwd:    File.join(@getBasePath(), '/')
      dest:   File.join(@getTmpPath(), 'templates', '/')
      filter: (file) => @fileCacheUpdateIfChanged(file)
    }]

    cfg