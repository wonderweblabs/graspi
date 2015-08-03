module.exports = class GraspiConfig

  constructor: (lodash, grunt, config, options = {}) ->
    @_              = lodash
    @g              = grunt
    @_config        = config
    @_options       = options
    @_smallMapping  = @_buildSmallMapping()

  getDefaultEnvironment: ->
    @_config.defaults.defaultEnvironment

  getEnvironmentNames: ->
    Object.keys(@_smallMapping)

  getModuleNames: ->
    @_.inject @_smallMapping, [], (memo, mod_names, env_name) =>
      @_.uniq(memo.concat(mod_names))

  getEmc: (env_name, mod_name) ->
    env = @getEnvironments()[env_name]
    mod = env.modules[mod_name]

    return null unless @_.isObject(mod)

    {
      config: @
      env_name: env_name
      mod_name: mod_name
      emc: mod
    }

  getEnvironments: ->
    @_config.environments

  eachEmc: (target1 = null, target2 = null, callback) ->
    return unless @_.isFunction(callback)

    target_env_name = @selectEnvironment(target1, target2)
    target_mod_name = if target_env_name != target1 then target1 else target2
    target_mod_name = null if !@_.isString(target_mod_name) || target_mod_name.length <= 0

    @_.each @getEnvironments(), (env, env_name) =>
      return unless env_name == target_env_name

      @_.each env.modules, (mod, mod_name) =>
        return unless target_mod_name == null || mod_name == target_mod_name

        callback(
          config: @
          env_name: env_name
          mod_name: mod_name
          emc: mod
        )

  emcForEnvMod: (req_env_name, req_mod_name) ->
    @_.inject @getEnvironments(), null, (memo, env, env_name) =>
      return memo if memo != null
      return memo if env_name != req_env_name

      @_.each env.modules, (mod, mod_name) =>
        return memo if memo != null
        return mod_name != req_mod_name

        memo =
          config: @
          env_name: env_name
          mod_name: mod_name
          emc: mod

  selectEnvironment: (target1, target2) ->
    environments = @getEnvironmentNames()

    return target1 if @_.includes environments, target1
    return target2 if @_.includes environments, target2

    @getDefaultEnvironment()


  # ----------------------------------------------------------
  # private

  # @nodoc
  _buildSmallMapping: ->
    @_.inject @_config.environments, {}, (memo_envs, env, env_name) =>
      memo_envs[env_name] = Object.keys(env.modules)
      memo_envs


