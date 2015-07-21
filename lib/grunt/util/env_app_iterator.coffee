_ = require('./lodash_extensions')

module.exports = (grunt) -> new EnvAppIterator(grunt)

class EnvAppIterator

  constructor: (grunt) ->
    @grunt  = grunt

  each: (configFile, callback) ->
    @eachWithTargets(configFile, null, null, callback)

  eachWithTargets: (configFile, target1, target2, callback) ->
    return unless _.isFunction(callback)

    config = require('./config')(@grunt, configFile)

    targets = []
    targets.push target1 if _.isString(target1) && !_.isEmpty(target1)
    targets.push target2 if _.isString(target2) && !_.isEmpty(target2)

    _.each config.getConfig(), (env, env_name) =>
      _.each env.apps, (app, app_name) =>
        openTargets = _.without targets, env_name
        openTargets = _.without targets, app_name

        return if _.any(openTargets)

        callback(
          env_name: env_name
          app_name: app_name
          env: env
          app: app
          appConfig: config.getApp(env_name, app_name)
        )

