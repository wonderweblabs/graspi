_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat_sourcemap'

  gruntTaskTargetAppendix: 'graspi-css-concat'

  cacheKeyAppendix: 'css-concat'

  cached: -> @getConfig().css.concat.cached == true

  isCacheValid: ->
    _.inject @getCssFiles(), true, (memo, file) =>
      if memo == false then false else !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  includeDependencies: ->
    @getConfig().css.concat.includeDependencies == true

  getCssFiles: ->
    files = []

    if @includeDependencies()
      deps = new Deps(@grunt)
      emcs = deps.buildDependenciesEmcList(@options)

      _.each emcs, (dep_emc) =>
        return if dep_emc.env_name == @getEnvName() && dep_emc.mod_name == @getModName()
        return if dep_emc.emc.webcomponent == true
        return unless _.isObject(dep_emc.emc.options.css)
        return unless _.isString(dep_emc.emc.options.css.destFile)

        destPath = @getDestPath(dep_emc)
        destFile = File.join(destPath, dep_emc.emc.options.css.destFile)
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
