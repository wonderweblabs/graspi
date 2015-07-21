module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'concat_sourcemap'

  getGruntTaskTarget: ->
    "graspi-js-copy-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().js.files)

    @_.isObject(@getAppConfig().js.files.jsFiles)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = [{
      expand: true
      ext:    '.js'
      src:    @getAppConfig().js.files.jsFiles || []
      cwd:    "#{@getAppConfig().js.basePath}"
      dest:   "#{@getConfig().tmp.js}/#{@getAppConfig().js.destFile}"
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    cfg