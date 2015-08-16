_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat_sourcemap'

  gruntTaskTargetAppendix: 'graspi-js-concat'

  cacheKeyAppendix: 'js-concat'

  cached: -> @getConfig().js.concat.cached == true

  isCacheValid: ->
    _.inject @getJsFiles(), true, (memo, file) =>
      if memo == false then false else !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getJsFiles: ->
    files = []

    if @includeDependencies()
      _.each @getModuleDependencies(), (module) =>
        return if module.getEnvName() == @getEnvName() && module.getModName() == @getModName()
        return if module.getEmcConfig().webcomponent == true
        return unless _.isObject(module.getEmcOptions().js)
        return unless _.isString(module.getEmcOptions().js.destFile)

        destPath = @getDestPath(module.getEmc())
        destFile = File.join(destPath, module.getEmcOptions().js.destFile)
        return unless @grunt.file.exists(destFile)

        files.push(destFile)

    files.concat @grunt.file.expand(File.join(@getTmpPath(), '**/*.js'))

  buildConfig: ->
    @grunt.file.delete(@getDestFilePath(), { force: true }) if @grunt.file.exists(@getDestFilePath())

    files = @getJsFiles()

    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = {}
    cfg.files[@getDestFilePath()] = files

    _.each files, (file) => @fileCacheUpdate(file)

    cfg
