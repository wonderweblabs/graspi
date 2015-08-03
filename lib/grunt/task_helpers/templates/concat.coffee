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

  includeDependencies: ->
    @getConfig().templates.concat.includeDependencies == true

  getFilesExpanded: ->
    return @_files if _.isArray(@_files)

    files = []
    files = files.concat(@_appendForDependencies(files))
    files = files.concat(@g.file.expand(File.join(@getTmpPath(), 'templates', '**/*.html')))

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

  # ----------------------------------------------------------
  # private

  # @nodoc
  _iterateDependencies: (eachFunc) ->
    return unless @includeDependencies()

    _.each @getDependencies().buildDependenciesEmCList(@getEnvName(), @getModName()), (emc) =>
      return if emc.env_name == @getEnvName() && emc.mod_name == @getModName()

      eachFunc(emc)

  # @nodoc
  _appendForDependencies: (files) ->
    @_iterateDependencies (emc) =>
      return if emc.env_name == @getEnvName() && emc.mod_name == @getModName()

      files = files.concat(@g.file.expand(File.join(emc.emc.options.destPath, "**/*.html")))

    files
