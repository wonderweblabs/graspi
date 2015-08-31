_         = require 'lodash'
File      = require 'path'
JsonFile  = require '../../util/json_file'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'shell'

  gruntTaskTargetAppendix: 'graspi-webcomponents-bower'

  cacheKeyAppendix: 'webcomponents-bower'

  cached: false

  enabled: -> super() && @grunt.file.exists(@getModuleBowerFile())

  isCacheValid: -> !@fileCacheHasChanged(@getModuleBowerFile())


  # ------------------------------------------------------------

  getModuleBowerFile: ->
    File.join(@getDestPath(), 'bower.json')

  getBowerFolder: ->
    return @getDestPath() unless _.isObject(@getConfig().webcomponents)
    return @getDestPath() unless _.isObject(@getConfig().webcomponents.bower)
    return @getDestPath() unless _.isString(@getConfig().webcomponents.bower.cwd)
    return @getDestPath() if _.isEmpty(@getConfig().webcomponents.bower.cwd)

    @getConfig().webcomponents.bower.cwd

  getBowerFile: ->
    File.join(@getConfig().webcomponents.bower.cwd, @getConfig().webcomponents.bower.jsonPath)

  buildConfig: ->
    cfg                     = {}
    cfg.options             = {}
    cfg.options.stdout      = true
    cfg.options.stderr      = true
    cfg.options.stdin       = true
    cfg.options.failOnError = true
    cfg.options.execOptions = {}
    cfg.options.execOptions.cwd = @getBowerFolder()
    cfg.command             = "bower update -V #{@getModName()}"
    cfg