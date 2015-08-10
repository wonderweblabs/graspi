_       = require 'lodash'
File    = require 'path'
FCT     = require('../file_change_tracker')

module.exports = class GraspiConfig

  constructor: (@grunt, @config) ->
    [@env_names, @mod_names] = @_buildSmallMapping()

    @_fileCacheTrackers = {}

  getRootPath: ->
    @grunt.option('root')

  getEnv: ->
    @grunt.option('env')

  getTask: ->
    @grunt.option('task')

  getConfigCacheFile: ->
    @grunt.option('configCache')

  getConfigLoadPaths: ->
    @grunt.option('configLoadPaths')

  getTaskHelperLoadPaths: ->
    @grunt.option('taskHelperLoadPaths')

  getGlobalCached: ->
    @grunt.option('cached')

  getGlobalDependenciesCached: ->
    @grunt.option('cachedDeps')

  getGlobalDependenciesResolve: ->
    @grunt.option('resolveDeps')

  getGlobalDependenciesIncluded: ->
    @grunt.option('includeDeps')

  getEnvironmentNames: ->
    @env_names

  getModuleNames: ->
    @mod_names

  getFileCacheTracker: (emc) ->
    return null unless _.isObject(emc)
    return null unless _.isObject(emc.emc)
    return null unless _.isString(emc.emc.cacheFile)

    @_fileCacheTrackers[emc.emc.cacheFile] or= @_buildFileCacheTracker(emc)

  getDestPath: (emc) ->
    File.join(@_getDestBasePath(emc), @_getDestFolder(emc))

  getEmc: (env_name, mod_name) ->
    env = @getEnvironments()[env_name]
    mod = env.modules[mod_name]

    return null unless _.isObject(mod)

    {
      config: @
      env_name: env_name
      mod_name: mod_name
      emc: mod
    }

  getEnvironments: ->
    @config.environments

  eachEmc: (target1 = null, target2 = null, callback) ->
    return unless _.isFunction(callback)

    target_env_name = @selectEnvironment(target1, target2)
    target_mod_name = if target_env_name != target1 then target1 else target2
    target_mod_name = null if !_.isString(target_mod_name) || target_mod_name.length <= 0

    _.each @getEnvironments(), (env, env_name) =>
      return unless env_name == target_env_name

      _.each env.modules, (mod, mod_name) =>
        return unless target_mod_name == null || mod_name == target_mod_name

        callback(
          config: @
          env_name: env_name
          mod_name: mod_name
          emc: mod
        )

  emcForEnvMod: (req_env_name, req_mod_name) ->
    _.inject @getEnvironments(), null, (memo, env, env_name) =>
      return memo if memo != null
      return memo if env_name != req_env_name

      _.each env.modules, (mod, mod_name) =>
        return memo if memo != null
        return mod_name != req_mod_name

        memo =
          config: @
          env_name: env_name
          mod_name: mod_name
          emc: mod

  selectEnvironment: (target1, target2) ->
    environments = @getEnvironmentNames()

    return target1 if _.includes environments, target1
    return target2 if _.includes environments, target2

    @getEnv()

  saveFileCacheTrackers: ->
    _.each @_fileCacheTrackers, (fct) =>
      @grunt.log.ok "Save cache - #{fct.getFilePath()}"
      fct.persist()

  # ----------------------------------------------------------
  # private

  # @nodoc
  _buildSmallMapping: ->
    result = [Object.keys(@config.environments)]

    result.push _.map @config.environments, (env, env_name) => Object.keys(env.modules)
    result[1] = _.uniq(result[1])

    result

  # @nodoc
  _buildFileCacheTracker: (emc) ->
    FCT(@grunt, emc.emc.cacheFile)

  # @nodoc
  _getDestBasePath: (emc) ->
    emc = emc.emc || {}

    path = emc.options.destPath if _.isObject(emc.options)

    path || emc.destPath

  # @nodoc
  _getDestFolder: (emc) ->
    emc = emc.emc || {}

    folder = emc.options.destFolder if _.isObject(emc.options)

    folder || emc.destFolder




