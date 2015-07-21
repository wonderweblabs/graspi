module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'cssmin'

  getGruntTaskTarget: ->
    "graspi-css-minify-#{super()}"

  getCacheKey: ->
    "css-minify-#{@eac.env_name}-#{@eac.app_name}"

  isEnabled: ->
    return false unless super() == true
    return false unless @getConfig().cssMinify.enabled == true

    @fileCacheHasChanged(@getDestFilePath())

  buildConfig: ->
    cfg                                 = {}
    cfg.options                         = {}
    cfg.options.report                  = @getConfig().cssMinify.report
    cfg.options.sourceMap               = @getConfig().cssMinify.sourceMap
    cfg.options.advanced                = @getConfig().cssMinify.cleanCss.advanced
    cfg.options.aggressiveMerging       = @getConfig().cssMinify.cleanCss.aggressiveMerging
    cfg.options.compatibility           = @getConfig().cssMinify.cleanCss.compatibility
    cfg.options.keepBreaks              = @getConfig().cssMinify.cleanCss.keepBreaks
    cfg.options.keepSpecialComments     = @getConfig().cssMinify.cleanCss.keepSpecialComments
    cfg.options.mediaMerging            = @getConfig().cssMinify.cleanCss.mediaMerging
    cfg.options.rebase                  = @getConfig().cssMinify.cleanCss.rebase
    cfg.options.restructuring           = @getConfig().cssMinify.cleanCss.restructuring
    cfg.options.roundingPrecision       = @getConfig().cssMinify.cleanCss.roundingPrecision
    cfg.options.semanticMerging         = @getConfig().cssMinify.cleanCss.semanticMerging
    cfg.options.shorthandCompacting     = @getConfig().cssMinify.cleanCss.shorthandCompacting
    cfg.options.sourceMapInlineSources  = @getConfig().cssMinify.cleanCss.sourceMapInlineSources

    cfg.files = {}
    cfg.files[@getDestFilePath()] = [@getDestFilePath()]

    @fileCacheUpdate(@getDestFilePath())

    cfg
