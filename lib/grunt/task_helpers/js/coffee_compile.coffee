module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'coffee'

  getGruntTaskTarget: ->
    "graspi-js-coffee_compile-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().js.files)
    return false unless @getConfig().jsCoffee.enabled == true

    @_.isObject(@getAppConfig().js.files.coffeeFiles)

  buildConfig: ->
    coffeeConfig = @getConfig().jsCoffee

    cfg                   = {}
    cfg.options           = {}
    cfg.options.bare      = coffeeConfig.bare
    cfg.options.sourceMap = coffeeConfig.sourceMap
    cfg.options.flatten   = false

    cfg.files = [{
      expand: true
      ext:    '.js'
      src:    @getAppConfig().js.files.coffeeFiles || []
      cwd:    "#{@getAppConfig().js.basePath}"
      dest:   "#{@getConfig().tmp.js}/#{@getAppConfig().js.destFile}"
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    cfg