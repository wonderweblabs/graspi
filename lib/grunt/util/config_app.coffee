_ = require('./lodash_extensions')

module.exports = class AppConfig

  constructor: (grunt, config, app_name) ->
    @name         = app_name
    @grunt        = grunt
    @globalConfig = config
    @configObject = {}

    @buildConfig()

  getConfig: (env) ->
    @configObject[env]

  configObject: ->
    @configObject

  buildConfig: ->
    _.each @globalConfig, (env, env_name) =>
      _.each env.apps, (app, app_name) =>
        return unless app_name == @name

        env_config = _.clone env, true
        delete env_config.environments
        delete env_config.apps

        app_config = _.clone app, true

        @configObject[env_name] = _.mergeRecursive(env_config, app_config)
        @configObject[env_name].app = app_name
