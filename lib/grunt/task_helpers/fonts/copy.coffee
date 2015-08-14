_     = require 'lodash'
File  = require 'path'

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

  getFontFiles: ->
    return @_fontFilesFull if _.isArray(@_fontFilesFull)

    files = []
    files = files.concat(@_appendForDependencies(files))
    files = files.concat(@_filesForModule(@getModule(), @getBasePath()))

    @_fontFilesFull = _.uniq(files)

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = []

    # dependencies
    @_iterateDependencies (module) =>
      srcList = _.map (module.getEmcConfig().fonts.copy.formats || []), (format) => "**/*.#{format}"
      cfg.files.push
        expand: true
        src: srcList
        cwd: @getDestPath(module.getEmc())
        dest: File.join(@getDestPath(), module.getModName())
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
    formats = module.getEmcConfig().fonts.copy.formats || []

    result = _.map formats, (format) => @grunt.file.expand(File.join(destPath, "**/*.#{format}"))
    result or= []

    _.uniq(_.flatten(result))