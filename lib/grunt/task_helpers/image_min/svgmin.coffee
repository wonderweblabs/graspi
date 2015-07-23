module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'svgmin'

  getGruntTaskTarget: ->
    "graspi-image-min-svgmin-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @getConfig().imageMin.enabled == true
    return false unless @_.isObject(@getAppConfig().images)

    true

  buildConfig: ->
    cfg                           = {}
    cfg.options                   = {}
    cfg.files = [{
      expand: true
      src: ["#{@getDestFullPath()}/{,*/}*.{svg}"]
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    cfg