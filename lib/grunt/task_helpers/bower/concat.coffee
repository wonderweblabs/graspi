module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'bower_concat'

  getGruntTaskTarget: ->
    "graspi-bower-concat-#{super()}"

  isEnabled: ->
    return false unless super() == true

    @eac.appConfig.bowerConcat._tmp.compile == true

  buildConfig: ->
    cfg = {}

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
      @_.each mainFiles, (path) =>
        @fileCacheUpdate(path)

      mainFiles

    cfg