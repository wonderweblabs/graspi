_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat_sourcemap'

  gruntTaskTargetAppendix: 'graspi-css-concat'

  cacheKeyAppendix: 'css-concat'

  cached: -> @getConfig().css.concat.cached == true

  isCacheValid: ->
    _.inject @getCssFiles(), true, (memo, file) =>
      if memo == false then false else !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getCssFiles: ->
    files = []

    if @includeDependencies()
      _.each @getModuleDependencies(), (module) =>
        return if module.getEnvName() == @getEnvName() && module.getModName() == @getModName()
        return if module.getEmcConfig().webcomponent == true
        return unless _.isObject(module.getEmcOptions().css)
        return unless _.isString(module.getEmcOptions().css.destFile)

        destPath = @getDestPath(module.getEmc())
        destFile = File.join(destPath, module.getEmcOptions().css.destFile)
        return unless @grunt.file.exists(destFile)

        files.push(destFile)

    files.concat @grunt.file.expand(File.join(@getTmpPath(), '**/*.css'))

  buildConfig: ->
    @grunt.file.delete(@getDestFilePath()) if @grunt.file.exists(@getDestFilePath())

    files = @getCssFiles()

    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = {}
    cfg.files[@getDestFilePath()] = files

    _.each files, (file) => @fileCacheUpdate(file)

    cfg
