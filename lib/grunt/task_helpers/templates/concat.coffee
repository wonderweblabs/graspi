_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

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

  includeDependencies: ->
    @getConfig().templates.concat.includeDependencies == true

  getFilesExpanded: ->
    return @_files if _.isArray(@_files)

    files = []

    if @includeDependencies()
      deps = new Deps(@grunt)
      emcs = deps.buildDependenciesEmcList(@options)

      _.each emcs, (dep_emc) =>
        return if dep_emc.env_name == @getEnvName() && dep_emc.mod_name == @getModName()
        return if dep_emc.emc.webcomponent == true
        return unless _.isObject(dep_emc.emc.options.templates)
        return unless _.isString(dep_emc.emc.options.templates.destFile)

        destPath = @getDestPath(dep_emc)
        destFile = File.join(destPath, dep_emc.emc.options.templates.destFile)
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