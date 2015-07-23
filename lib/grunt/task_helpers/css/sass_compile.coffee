module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'sass'

  getGruntTaskTarget: ->
    "graspi-css-sass_compile-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().css.files)
    return false unless @getConfig().cssSass.enabled == true

    @_.isObject(@getAppConfig().css.files.sassFiles)

  buildConfig: ->
    sassConfig = @getConfig().cssSass

    changed = false

    @_.each @g.file.expand("#{@getAppConfig().css.basePath}/**/*.{sass,scss}"), (file) =>
      return if changed == true
      return if @fileCacheHasChanged(file) == false
      changed = true

    return {} unless changed == true

    cfg                         = {}
    cfg.options                 = {}
    cfg.options.trace           = sassConfig.trace
    cfg.options.cacheLocation   = sassConfig.cacheLocation
    cfg.options.compass         = sassConfig.compass
    cfg.options.debugInfo       = sassConfig.debugInfo
    cfg.options.lineNumbers     = sassConfig.lineNumbers
    cfg.options.precision       = sassConfig.precision
    cfg.options.quiet           = sassConfig.quiet
    cfg.options.sourcemap       = sassConfig.sourcemap
    cfg.options.style           = sassConfig.style
    cfg.options.update          = sassConfig.update
    cfg.options.loadPath        = @_.clone(sassConfig.loadPath)
    cfg.files                   = [{
      expand: true
      ext:    '.css'
      src:    @getAppConfig().css.files.sassFiles || []
      cwd:    "#{@getAppConfig().css.basePath}"
      dest:   "#{@getConfig().tmp.css}/#{@getAppConfig().css.destFile}"
    }]

    cfg.options.loadPath.push @getAppConfig().css.basePath

    @_.each @g.file.expand("#{@getAppConfig().css.basePath}/**/*.{sass,scss}"), (file) =>
      @fileCacheUpdate(file)

    cfg