module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'concat_sourcemap'

  getGruntTaskTarget: ->
    "graspi-js-concat-#{super()}"

  getFilesUrl: ->
    "#{@getConfig().tmp.js}/#{@getAppConfig().js.destFile}/{,*/}*.js"

  buildConfig: ->
    updateNecessary = false

    files = @g.file.expand(@getFilesUrl())

    @_.each files, (file) =>
      return unless updateNecessary == false
      return unless @fileCacheHasChanged(file)
      updateNecessary = true

    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = {}

    if updateNecessary == true
      @_.each files, (file) => @fileCacheUpdate(file)

      cfg.files[@getDestFilePath()] = [@getFilesUrl()]

    cfg