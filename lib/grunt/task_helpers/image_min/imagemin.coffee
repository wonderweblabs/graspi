JpegRecompress = require('imagemin-jpeg-recompress')

module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'imagemin'

  getGruntTaskTarget: ->
    "wwl-image-min-imagemin-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @getConfig().imageMin.enabled == true
    return false unless @_.isObject(@getAppConfig().images)

    true

  isJpegRecompressEnabled: ->
    return false unless @_.isObject(@getConfig().imageMin.jpegRecompressPlugin)

    @getConfig().imageMin.jpegRecompressPlugin.enabled == true

  buildConfig: ->
    cfg                           = {}
    cfg.options                   = {}
    cfg.options.optimizationLevel = @getConfig().imageMin.optimizationLevel
    cfg.options.progressive       = @getConfig().imageMin.progressive
    cfg.options.interlaced        = @getConfig().imageMin.interlaced
    cfg.options.use               = []

    cfg.files = [{
      expand: true
      src: ["#{@getDestFullPath()}/{,*/}*.{jpeg,jpg,gif,png}"]
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    if @isJpegRecompressEnabled()
      jpegCompressPluginConfig = @buildJpegCompressPluginConfig()
      cfg.options.use.push JpegRecompress(jpegCompressPluginConfig)

    cfg

  buildJpegCompressPluginConfig: ->
    pluginConfig = @getConfig().imageMin.jpegRecompressPlugin

    cfg = {}

    cfg.loops       = pluginConfig.loops
    cfg.accurate    = pluginConfig.accurate
    cfg.quality     = pluginConfig.quality
    cfg.method      = pluginConfig.method
    cfg.target      = pluginConfig.target
    cfg.min         = pluginConfig.min
    cfg.max         = pluginConfig.max
    cfg.defish      = pluginConfig.defish
    cfg.progressive = pluginConfig.progressive
    cfg.subsample   = pluginConfig.subsample

    cfg



