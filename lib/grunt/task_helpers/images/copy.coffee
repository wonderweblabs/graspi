_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'copy'

  gruntTaskTargetAppendix: 'graspi-images-copy'

  cacheKeyAppendix: 'images-copy'

  cached: -> @getConfig().images.copy.cached == true

  enabled: -> super() && _.isObject(@getAppConfig().images.files)

  isCacheValid: ->
    _.inject @getImagesFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  includeDependencies: ->
    @getConfig().images.copy.includeDependencies == true

  getImagesFiles: ->
    return @_imageFiles if _.isArray(@_imageFiles)

    files = []
    files = files.concat(@_appendForDependencies(files))
    files = files.concat(@_filesForEmc(@getEmc(), @getBasePath()))

    @_imageFiles = _.uniq(files)

  getDependencies: ->
    @_deps or= new Deps(@grunt)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = []

    # dependencies
    @_iterateDependencies (emc) =>
      srcList = _.map (emc.emc.images.copy.formats || []), (format) => "**/*.#{format}"
      cfg.files.push
        expand: true
        src: srcList
        cwd: emc.emc.options.destPath
        dest: File.join(@getDestPath(), emc.mod_name)
        filter: (file) => @fileCacheUpdateIfChanged(file)

    # module
    srcList = _.map (@getConfig().images.copy.formats || []), (format) => "**/*.#{format}"
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

    _.each @getDependencies().buildDependenciesEmcList(@options), (emc) =>
      return if emc.env_name == @getEnvName() && emc.mod_name == @getModName()

      eachFunc(emc)

  # @nodoc
  _appendForDependencies: (files) ->
    @_iterateDependencies (emc) =>
      return if emc.env_name == @getEnvName() && emc.mod_name == @getModName()

      files = files.concat(@_filesForEmc(emc, emc.emc.options.destPath))

    files

  # @nodoc
  _filesForEmc: (emc, path) ->
    formats = emc.emc.images.copy.formats || []

    result = _.map formats, (format) => @grunt.file.expand(File.join(path, "**/*.#{format}"))
    result or= []

    _.uniq(_.flatten(result))


