module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'concat_sourcemap'

  getGruntTaskTarget: ->
    "graspi-css-copy-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getAppConfig().css.files)

    @_.isObject(@getAppConfig().css.files.cssFiles)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = [{
      expand: true
      ext:    '.css'
      src:    @getAppConfig().css.files.cssFiles || []
      cwd:    "#{@getAppConfig().css.basePath}"
      dest:   "#{@getConfig().tmp.css}/#{@getAppConfig().css.destFile}"
      filter: (path) =>
        changed = @fileCacheHasChanged(path)

        @fileCacheUpdate(path) if changed == true

        changed
    }]

    cfg