_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'copy'

  gruntTaskTargetAppendix: 'graspi-fonts-copy'

  cacheKeyAppendix: 'fonts-copy'

  cached: -> @getConfig().fonts.copy.cached == true

  enabled: -> super() && _.isObject(@getAppConfig().fonts.files)

  isCacheValid: ->
    _.inject @getFontFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  includeDependencies: ->
    @getConfig().fonts.copy.includeDependencies == true

  getFontFiles: ->
    return @_fontFilesFull if _.isArray(@_fontFilesFull)

    files = []
    files = files.concat(@_appendForDependencies(files))
    files = files.concat(@_filesForEmc(@emc, @getBasePath()))

    @_fontFilesFull = _.uniq(files)

  getDependencies: ->
    @_deps or= new Deps(_, @g, @emc.config)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = []

    # dependencies
    @_iterateDependencies (emc) =>
      srcList = _.map (emc.emc.fonts.copy.formats || []), (format) => "**/*.#{format}"
      cfg.files.push
        expand: true
        src: srcList
        cwd: emc.emc.options.destPath
        dest: File.join(@getDestPath(), emc.mod_name)
        filter: (file) => @fileCacheUpdateIfChanged(file)

    # module
    srcList = _.map (@getConfig().fonts.copy.formats || []), (format) => "**/*.#{format}"
    cfg.files.push
      expand: true
      src:    srcList
      cwd:    @getBasePath()
      dest:   @getDestPath()
      filter: (file) => @fileCacheUpdateIfChanged(file)

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
      files = files.concat(@_filesForEmc(emc, emc.emc.options.destPath))

    files

  # @nodoc
  _filesForEmc: (emc, path) ->
    formats = emc.emc.fonts.copy.formats || []

    result = _.map formats, (format) => @g.file.expand(File.join(path, "**/*.#{format}"))
    result or= []

    _.uniq(_.flatten(result))