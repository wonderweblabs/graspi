_       = require 'lodash'
File    = require 'path'
Config  = require './config'

module.exports = class GraspiConfigBuilder

  constructor: (@grunt) ->

  getConfigCacheFile: ->
    @grunt.option('configCache')

  getConfigLoadPaths: ->
    @grunt.option('configLoadPaths')

  getJsonFileHandler: ->
    @_jsonFileHandler or= require('../json_file')(@grunt)

  getYamlFileHandler: ->
    @_yamlFileHandler or= require('../yaml_file')(@grunt)

  getFileChangeTracker: ->
    file = @getConfigCacheFile().replace(/\.yml$/, '')
    file += '-cfg.yml'

    @_fileChangeTracker or= require('../file_change_tracker')(@grunt, file)

  configure: ->
    @prepareConfigInstance(@load())

  load: ->
    config = @_loadCachedConfig(@getConfigCacheFile())

    return config unless @_hasConfigChanged(config)

    configs     = []
    finalConfig = {
      options:
        gruntRoot:            @grunt.option('root')
        configCache:          @getConfigCacheFile()
        configLoadPaths:      @getConfigLoadPaths()
        tasksLoadPaths:       @grunt.option('tasksLoadPaths')
        taskHelperLoadPaths:  @grunt.option('taskHelperLoadPaths')
    }

    _.each @getConfigLoadPaths(), (configLoadPath) =>
      tmpCfg =
        defaults:     @_loadDefaultsFromFile(configLoadPath)
        environments: @_loadEnvironmentsFromFolder(configLoadPath)
        modules:      @_loadModulesFromFolder(configLoadPath)

      @_collectEnvironmentsAndModules(tmpCfg, finalConfig)
      configs.push tmpCfg

    _.each configs, (tmpCfg) =>
      @_mergeDefaults(tmpCfg.defaults, finalConfig)
      @_mergeEnvironments(tmpCfg.environments, finalConfig)
      @_mergeModules(tmpCfg.modules, finalConfig)

    @_updateChangeTracker(@_loadConfigFilesList())
    @_persistCachedConfig(finalConfig)

    finalConfig

  prepareConfigInstance: (config) ->
    new Config(@grunt, config)


  # ----------------------------------------------------------
  # private

  # @nodoc
  _loadCachedConfig: (configTmpFile) ->
    @getJsonFileHandler().read(configTmpFile).mergedConfig || {}

  # @nodoc
  _hasConfigChanged: (config) ->
    return true unless _.isObject(config)

    fsConfigFiles = @_loadConfigFilesList()

    return @_haveFilesChanged(fsConfigFiles)

  # @nodoc
  _loadDefaultsFromFile: (folderPath) ->
    file = File.join(folderPath, 'defaults.yml')

    return {} unless @grunt.file.exists(file)

    @getYamlFileHandler().read(file) || {}

  # @nodoc
  _loadEnvironmentsFromFolder: (folderPath) ->
    folder = File.join(folderPath, 'environments')

    return {} unless @grunt.file.exists(folder)

    _.inject @grunt.file.expand("#{folder}/*"), {}, (memo, file) =>
      name = File.basename(file, File.extname(file))
      memo[name] = @getYamlFileHandler().read(file) || {}
      memo

  # @nodoc
  _loadModulesFromFolder: (folderPath) ->
    folder = File.join(folderPath, 'modules')

    return {} unless @grunt.file.exists(folder)

    _.inject @grunt.file.expand("#{folder}/*"), {}, (memo, file) =>
      name = File.basename(file, File.extname(file))
      memo[name] = @getYamlFileHandler().read(file) || {}
      memo

  # @nodoc
  _collectEnvironmentsAndModules: (cfg, finalConfig) ->
    finalConfig               or= {}
    finalConfig.defaults      or= {}
    finalConfig.environments  or= {}
    mods = finalConfig.modules || []

    # defaults.yml
    _.each cfg.defaults.environments, (e, env_name) =>
      finalConfig.environments[env_name]          or= {}
      finalConfig.environments[env_name].defaults or= {}
      mods = mods.concat(e.modules || [])

    # environments
    _.each cfg.environments, (e, env_name) =>
      finalConfig.environments[env_name]          or= {}
      finalConfig.environments[env_name].defaults or= {}
      mods = mods.concat(e.modules || [])

    # modules
    _.each cfg.modules, (mod, mod_name) =>
      mods.push mod_name

      _.each mod.environments, (e, env_name) =>
        finalConfig.environments[env_name]          or= {}
        finalConfig.environments[env_name].defaults or= {}

    # assign environment modules
    _.each finalConfig.environments, (e, env_name) =>
      e.modules or= {}

      _.each mods, (mod_name) =>
        e.modules[mod_name] or= {}

    finalConfig

  # @nodoc
  _mergeDefaults: (cfg, finalConfig) ->
    defaults = _.clone(cfg)
    delete defaults.environments
    delete defaults.modules

    # merge defaults
    finalConfig.defaults = _.mergeRecursive(finalConfig.defaults, defaults)
    delete defaults.defaultEnvironment

    # merge environments
    _.each finalConfig.environments, (env, env_name) =>
      env.defaults = _.mergeRecursive(env.defaults, defaults)
      _.each Object.keys(env.modules), (mod_name) =>
        env.modules[mod_name] = _.mergeRecursive(env.modules[mod_name], defaults)

    # envs and modules
    @_mergeEnvironments(_.clone(cfg.environments || {}), finalConfig)
    @_mergeModules(_.clone(cfg.modules || {}), finalConfig)

  # @nodoc
  _mergeEnvironments: (environments, finalConfig) ->
    _.each environments, (env, env_name) =>
      config = _.clone(env)
      delete config.modules
      delete config.defaultEnvironment

      # merge environment
      envConfig = (finalConfig.environments[env_name] || {}).defaults
      envConfig or= {}
      envConfig = _.mergeRecursive(envConfig, config)
      finalConfig.environments[env_name].defaults = envConfig

      # merge modules
      e = finalConfig.environments[env_name]
      _.each Object.keys(e.modules), (mod_name) =>
        e.modules[mod_name] = _.mergeRecursive(e.modules[mod_name], envConfig)

      # merge modules
      @_mergeModules(_.clone(env.modules || {}), finalConfig)

  # @nodoc
  _mergeModules: (modules, finalConfig) ->
    _.each finalConfig.environments, (env, env_name) =>
      _.each Object.keys(env.modules), (mod_name) =>
        return unless _.isObject(modules[mod_name])

        config = _.clone(modules[mod_name])
        delete config.environments
        delete config.defaultEnvironment

        # merge module
        modConfig = _.mergeRecursive(env.modules[mod_name], config)
        env.modules[mod_name] = modConfig

        # merge environment config
        return unless _.isObject(modules[mod_name].environments)
        return unless _.isObject(modules[mod_name].environments[env_name])

        config = _.clone(modules[mod_name].environments[env_name])
        modConfig = _.mergeRecursive(modConfig, config)
        env.modules[mod_name] = modConfig

  # @nodoc
  _updateChangeTracker: (files) ->
    @getFileChangeTracker().update(files, 'configFiles')
    @getFileChangeTracker().persist()

  # @nodoc
  _persistCachedConfig: (config) ->
    mapping = @getJsonFileHandler().read(@getConfigCacheFile()) || {}
    mapping.mergedConfig = config

    @getJsonFileHandler().write(@getConfigCacheFile(), mapping)

  # @nodoc
  _loadConfigFilesList: ->
    fsConfigFiles = _.inject @getConfigLoadPaths(), [], (memo, folder) =>
      memo = memo.concat(@grunt.file.expand({filter: 'isFile'}, "#{folder}/{,*/}*"))
      memo

    _.uniq(fsConfigFiles)

  # @nodoc
  _haveFilesChanged: (files) ->
    _.inject files, false, (memo, file) =>
      return memo if memo == true
      @getFileChangeTracker().hasChanged(file, 'configFiles')

