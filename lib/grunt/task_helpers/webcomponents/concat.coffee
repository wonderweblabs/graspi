_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat'

  gruntTaskTargetAppendix: 'graspi-webcomponents-concat'

  cacheKeyAppendix: 'webcomponents-concat'

  cached: -> @getConfig().webcomponents.concat.cached == true

  isCacheValid: ->
    _.inject @getFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------


  getFiles: ->
    return @_files if _.isArray(@_files)
    return [] unless @includeDependencies()

    files = []

    _.each @getModuleDependencies(), (module) =>
      return if module.getEnvName() == @getEnvName() && module.getModName() == @getModName()
      return if module.getEmcConfig().webcomponent != true
      return unless _.isObject(module.getEmcOptions().templates)
      return unless _.isString(module.getEmcOptions().templates.destFile)

      destPath = @getDestPath(module.getEmc())
      destFile = File.join(destPath, module.getEmcOptions().templates.destFile)
      return unless @grunt.file.exists(destFile)

      files.push(destFile)

    @_files = _.uniq(files)


  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.sourceMap = false
    cfg.src               = @getFiles()
    cfg.dest              = @getDestFile()

    cfg
