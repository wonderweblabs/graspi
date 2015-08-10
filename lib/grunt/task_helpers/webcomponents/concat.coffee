_     = require 'lodash'
File  = require 'path'
Deps  = require '../../util/class/task_runner/dependencies'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat'

  gruntTaskTargetAppendix: 'graspi-webcomponents-concat'

  cacheKeyAppendix: 'webcomponents-concat'

  cached: -> @getConfig().webcomponents.concat.cached == true

  isCacheValid: ->
    _.inject @getFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  includeDependencies: ->
    @getConfig().webcomponents.concat.includeDependencies == true

  getFiles: ->
    return @_files if _.isArray(@_files)
    return [] unless @includeDependencies()

    depList = @getDependencies().buildDependenciesEmcList(@options)
    files = _.inject depList, [], (memo, emc) =>
      return memo if emc.env_name == @getEnvName() && emc.mod_name == @getModName()
      return memo unless _.isObject(emc.emc.options.templates)
      return memo unless _.isString(emc.emc.options.templates.destFile)

      destPath = emc.emc.options.templates.destPath
      destPath or= emc.emc.options.destPath
      destFile = File.join(destPath, emc.emc.options.templates.destFile)
      return memo unless @grunt.file.exists(destFile)

      memo.push destFile
      memo

    @_files = _.uniq(files)

  getDependencies: ->
    @_deps or= new Deps(@grunt)

  buildConfig: ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.sourceMap = false
    cfg.src               = @getFiles()
    cfg.dest              = @getDestFile()

    cfg
