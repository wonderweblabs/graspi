_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'haml'

  gruntTaskTargetAppendix: 'graspi-templates-haml'

  cacheKeyAppendix: 'templates-haml'

  cached: -> @getConfig().templates.haml.cached == true

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
      memo.push file if /\.haml$/.test(file)
      memo.push file if /\.hamlc$/.test(file)
      memo

  getFilesExpanded: ->
    _.inject @getFiles(), [], (memo, file) =>
      file = File.join(@getBasePath(), file)

      return memo.concat(@grunt.file.expand({ filter: 'isFile' }, file)) unless @g.file.isFile(file)

      memo.push file
      memo

  buildConfig: ->
    config = _.inject @getConfig().templates.haml.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg         = {}
    cfg.options = config
    cfg.files   = [{
      expand: true
      ext:    '.html'
      src:    @getFiles()
      cwd:    File.join(@getBasePath(), '/')
      dest:   File.join(@getTmpPath(), 'templates', '/')
      filter: (file) => @fileCacheUpdateIfChanged(file)
    }]

    cfg

