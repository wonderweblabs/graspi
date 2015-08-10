_               = require 'lodash'
File            = require 'path'
JpegRecompress  = require('imagemin-jpeg-recompress')

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'imagemin'

  gruntTaskTargetAppendix: 'graspi-images-imagemin'

  cacheKeyAppendix: 'images-imagemin'

  cached: -> @getConfig().images.imagemin.cached == true

  isCacheValid: ->
    _.inject @getImagesFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getImagesFiles: ->
    return @_imageFiles if _.isArray(@_imageFiles)

    @_imageFiles = []

    _.each @getConfig().images.imagemin.formats.images, (format) =>
      path = File.join(@getDestPath(), "**/*.#{format}")
      files = @grunt.file.expand(path)

      @_imageFiles = @_imageFiles.concat(files) if _.isArray(files)

    @_imageFiles = _.uniq(@_imageFiles)
    @_imageFiles


  isJpegRecompressEnabled: ->
    return false unless _.isObject(@getConfig().images.imagemin.plugins)
    return false unless _.isObject(@getConfig().images.imagemin.plugins.jpegRecompressPlugin)

    _.includes(@getConfig().images.imagemin.usePlugins, 'jpegRecompressPlugin')

  buildConfig: ->
    config = _.inject @getConfig().images.imagemin.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg             = {}
    cfg.options     = config
    cfg.options.use = []

    cfg.files = [{
      expand: true
      src:    @getImagesFiles()
      filter: (file) => @fileCacheUpdateIfChanged(file)
    }]

    if @isJpegRecompressEnabled()
      jpegCompressPluginConfig = @buildJpegCompressPluginConfig()
      cfg.options.use.push JpegRecompress(jpegCompressPluginConfig)

    cfg

  buildJpegCompressPluginConfig: ->
    _.inject @getConfig().images.imagemin.plugins.jpegRecompressPlugin, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

