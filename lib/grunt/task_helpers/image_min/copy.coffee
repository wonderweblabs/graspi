module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'copy'

  getGruntTaskTarget: ->
    "wwl-image-min-copy-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().images)
    return false unless @_.isObject(@getAppConfig().images.files)
    return false unless @_.isObject(@getAppConfig().images.files.imageFiles)

    true

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false

    cfg.files                  = [{
      expand: true
      src:    @getAppConfig().images.files.imageFiles || []
      cwd:    "#{@getAppConfig().images.basePath}"
      dest:   "#{@getAppConfig().images.destPath}"
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    cfg