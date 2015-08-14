_     = require 'lodash'
File  = require 'path'

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

  getImagesFiles: ->
    return @_imageFiles if _.isArray(@_imageFiles)

    files = []
    files = files.concat(@_appendForDependencies(files))
    files = files.concat(@_filesForModule(@getModule(), @getBasePath()))

    @_imageFiles = _.uniq(files)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = []

    # dependencies
    @_iterateDependencies (module) =>
      srcList = _.map (module.getEmcConfig().images.copy.formats || []), (format) => "**/*.#{format}"
      cfg.files.push
        expand: true
        src: srcList
        cwd: @getDestPath(module.getEmc())
        dest: File.join(@getDestPath(), module.getModName())
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

    _.each @getModuleDependencies(), (module) =>
      return if module.getEnvName() == @getEnvName() && module.getModName() == @getModName()

      eachFunc(module)

  # @nodoc
  _appendForDependencies: (files) ->
    @_iterateDependencies (module) =>
      destPath = File.join(@getDestPath(module.getEmc()))

      files = files.concat(@_filesForModule(module, destPath))

    files

  # @nodoc
  _filesForModule: (module, destPath) ->
    formats = module.getEmcConfig().images.copy.formats || []

    result = _.map formats, (format) => @grunt.file.expand(File.join(destPath, "**/*.#{format}"))
    result or= []

    _.uniq(_.flatten(result))


