module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'bower_concat'

  getGruntTaskTarget: ->
    "graspi-bower-concat-check-#{super()}"

  buildConfig: ->
    cfg = {}

    @eac.appConfig.bowerConcat._tmp         = {}
    @eac.appConfig.bowerConcat._tmp.compile = false

    if @_.isObject(@eac.appConfig.config.js)
      cfg.dest = "#{@eac.appConfig.tmp.js}/#{@eac.appConfig.config.js.destFile}/1_bower.js"

    if @_.isObject(@eac.appConfig.config.css)
      cfg.cssDest   = "#{@eac.appConfig.tmp.css}/#{@eac.appConfig.config.css.destFile}/1_bower.css"

    if @_.isArray(@eac.appConfig.bowerConcat.include)
      cfg.include = @eac.appConfig.bowerConcat.include
    else if @_.isArray(@eac.appConfig.bowerConcat.exclude)
      cfg.exclude = @eac.appConfig.bowerConcat.exclude

    if @_.isObject(@eac.appConfig.bowerConcat.dependencies)
      cfg.dependencies = @eac.appConfig.bowerConcat.dependencies

    cfg.callback = (mainFiles, component) =>
      return [] if @eac.appConfig.bowerConcat._tmp.compile == true

      @_.each mainFiles, (path) =>
        return if @eac.appConfig.bowerConcat._tmp.compile == true
        return if @fileCacheHasChanged(path) == false

        @eac.appConfig.bowerConcat._tmp.compile = true

      []

    cfg