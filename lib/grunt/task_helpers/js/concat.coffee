_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat_sourcemap'

  gruntTaskTargetAppendix: 'graspi-js-concat'

  cacheKeyAppendix: 'js-concat'

  cached: -> @getConfig().js.concat.cached == true

  isCacheValid: ->
    _.inject @getJsFiles(), true, (memo, file) =>
      if memo == false then false else !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  includeDependencies: ->
    @getConfig().js.concat.includeDependencies == true

  getJsFiles: ->
    files = []

    if @includeDependencies()
      deps = new Deps(_, @g, @emc.config)
      emcs = deps.buildDependenciesEmCList(@getEnvName(), @getModName())

      _.each emcs, (dep_emc) =>
        return if dep_emc.env_name == @getEnvName() && dep_emc.mod_name == @getModName()
        return if dep_emc.emc.webcomponent == true
        return unless _.isObject(dep_emc.emc.options.js)
        return unless _.isString(dep_emc.emc.options.js.destFile)

        destPath = dep_emc.emc.options.js.destPath
        destPath or= dep_emc.emc.options.destPath
        destFile = File.join(destPath, dep_emc.emc.options.js.destFile)
        return unless @g.file.exists(destFile)

        files.push(destFile)

    files.concat @g.file.expand(File.join(@getTmpPath(), '**/*.js'))

  buildConfig: ->
    @g.file.delete(@getDestFilePath()) if @g.file.exists(@getDestFilePath())

    files = @getJsFiles()

    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = {}
    cfg.files[@getDestFilePath()] = files

    _.each files, (file) => @fileCacheUpdate(file)

    cfg
