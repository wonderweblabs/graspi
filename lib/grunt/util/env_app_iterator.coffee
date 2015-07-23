_ = require('./lodash_extensions')

module.exports = (grunt, config) -> new EnvAppIterator(grunt, config)

class EnvAppIterator

  constructor: (grunt, config) ->
    @grunt  = grunt
    @config = config

  each: (callback) ->
    @eachWithTargets(null, null, callback)

  eachWithTargets: (target1, target2, callback) ->
    return unless _.isFunction(callback)

    targets = []
    targets.push target1 if _.isString(target1) && !_.isEmpty(target1)
    targets.push target2 if _.isString(target2) && !_.isEmpty(target2)

    _.each @config.getConfig(), (env, env_name) =>
      _.each env.apps, (app, app_name) =>
        openTargets = _.remove _.clone(targets), (t) =>
          t != env_name && t != app_name

        return if _.any(openTargets)

        callback(
          env_name: env_name
          app_name: app_name
          env: env
          app: app
          appConfig: @config.getApp(env_name, app_name)
        )

