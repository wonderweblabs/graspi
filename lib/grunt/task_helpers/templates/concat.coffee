_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat'

  gruntTaskTargetAppendix: 'graspi-templates-concat'

  cacheKeyAppendix: 'templates-concat'

  cached: -> @getConfig().templates.concat.cached == true

  isCacheValid: ->
    _.inject @getFilesExpanded(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getFilesExpanded: ->
    return @_files if _.isArray(@_files)

    files = []

    if @includeDependencies()
      _.each @getModuleDependencies(), (module) =>
        return if module.getEnvName() == @getEnvName() && module.getModName() == @getModName()
        return if module.getEmcConfig().webcomponent == true
        return unless _.isObject(module.getEmcOptions().templates)
        return unless _.isString(module.getEmcOptions().templates.destFile)

        destPath = @getDestPath(module.getEmc())
        destFile = File.join(destPath, module.getEmcOptions().templates.destFile)
        return unless @grunt.file.exists(destFile)

        files.push(destFile)

    emcFiles = _.map (@getAppConfig().templates.files || []), (file) =>
      file = file.replace(/haml$/, 'html')
      File.join(@getTmpPath(), 'templates', file)

    files = files.concat(emcFiles)

    @_files = _.uniq(files)

  getDependencies: ->
    @_deps or= new Deps(_, @g, @emc.config)

  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.sourceMap = false
    cfg.src               = @getFilesExpanded()
    cfg.dest              = @getDestFile()

    cfg