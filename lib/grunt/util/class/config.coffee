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

  getEnvironments: ->
    @config.environments

  getFileCacheTracker: (emc) ->
    return null unless _.isObject(emc)
    return null unless _.isObject(emc.emc)
    return null unless _.isString(emc.emc.cacheFile)

    @_fileCacheTrackers[emc.emc.cacheFile] or= @_buildFileCacheTracker(emc)

  getDestPath: (emc) ->
    File.join(@getDestBasePath(emc), @getDestFolder(emc))

  getDestBasePath: (emc) ->
    emc = emc.emc || {}

    path = emc.options.destPath if _.isObject(emc.options)

    path || emc.destPath

  getDestFolder: (emc) ->
    emc = emc.emc || {}

    folder = emc.options.destFolder if _.isObject(emc.options)

    folder || emc.destFolder

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

  eachEmc: (target_env_name = null, target_mod_name = null, callback) ->
    return unless _.isFunction(callback)

    _.each @getEnvironments(), (env, env_name) =>
      return unless target_env_name == null || env_name == target_env_name

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





