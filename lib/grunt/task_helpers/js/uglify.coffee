module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'uglify'

  getGruntTaskTarget: ->
    "graspi-js-uglify-#{super()}"

  getCacheKey: ->
    "js-uglify-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @getConfig().jsUglify.enabled == true

    @fileCacheHasChanged(@getDestFilePath())

  buildConfig: ->
    jsUglifyConfig = @getConfig().jsUglify.options

    cfg                               = {}
    cfg.options                       = {}
    cfg.options.report                = @getConfig().jsUglify.report
    cfg.options.sourceMap             = @getConfig().jsUglify.sourceMap
    cfg.options.mangle                = jsUglifyConfig.mangle
    cfg.options.beautify              = jsUglifyConfig.beautify
    cfg.options.maxLineLen            = jsUglifyConfig.maxLineLen
    cfg.options.ASCIIOnly             = jsUglifyConfig.ASCIIOnly
    cfg.options.exportAll             = jsUglifyConfig.exportAll
    cfg.options.preserveComments      = jsUglifyConfig.preserveComments
    cfg.options.banner                = jsUglifyConfig.banner
    cfg.options.footer                = jsUglifyConfig.footer
    cfg.options.screwIE8              = jsUglifyConfig.screwIE8
    cfg.options.mangleProperties      = jsUglifyConfig.mangleProperties
    cfg.options.reserveDOMProperties  = jsUglifyConfig.reserveDOMProperties
    cfg.options.nameCache             = jsUglifyConfig.nameCache
    cfg.options.quoteStyle            = jsUglifyConfig.quoteStyle

    cfg.files = {}
    cfg.files[@getDestFilePath()] = [@getDestFilePath()]

    @fileCacheUpdate(@getDestFilePath())

    cfg