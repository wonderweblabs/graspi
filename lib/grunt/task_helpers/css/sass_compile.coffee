_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'sass'

  gruntTaskTargetAppendix: 'graspi-css-sass_compile'

  cacheKeyAppendix: 'css-sass'

  cached: -> @getConfig().css.sass.cached == true

  enabled: -> super() && _.size(@getSassFiles()) > 0

  isCacheValid: ->
    _.inject @getAllSassFiles(), true, (memo, file) =>
      return false if memo == false
      return memo unless @grunt.file.isFile(file)

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getAllSassFiles: ->
    @_allSassFiles or= @grunt.file.expand(File.join(@getBasePath(), '**/*.{sass,scss}'))

  getSassFiles: ->
    @_sassFiles or= _.inject (@getAppConfig().css.files || []), [], (memo, file) =>
      memo.push file if /\.(sass|scss)$/.test(file)
      memo

  buildConfig: ->
    sassConfig = _.inject @getConfig().css.sass.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    sassFiles = _.inject @getSassFiles(), [], (memo, filesEntry) =>
      filesEntry = File.join(@getBasePath(), filesEntry)
      filesEntry = @grunt.file.expand(filesEntry) if !@grunt.file.isFile(filesEntry)
      filesEntry = [filesEntry] unless _.isArray(filesEntry)

      memo.concat(filesEntry)

    tmpFile = File.join(@getTmpPath(), @getAppConfig().css.destFile)

    cfg                   = {}
    cfg.options           = sassConfig
    cfg.options.loadPath  = _.clone(sassConfig.loadPath) || []
    cfg.options.loadPath.push @getAppConfig().css.basePath
    cfg.files             = {}
    cfg.files[tmpFile]    = sassFiles

    _.each sassFiles, (file) => @fileCacheUpdate(file)

    cfg
