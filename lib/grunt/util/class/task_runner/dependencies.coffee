Cache = require('./cache')

module.exports = class Dependencies

  constructor: (lodash, grunt, config) ->
    @_        = lodash
    @g        = grunt
    @config   = config

  getEmc: (env_name, mod_name) ->
    @config.getEmc(env_name, mod_name)

  getCache: ->
    @_cache or= new Cache(@g)

  getBuildTaskName: ->
    'graspi_build'

  buildExecutionList: (env_name, mod_name, task_name, defaultTaskName = null, caching = true) ->
    modules     = {}
    modulesList = []
    defaultTaskName or= @getBuildTaskName()

    @_resolveDependencies(env_name, mod_name, modules, modulesList, [], caching)

    @_.inject modulesList, [], (memo, mn) =>
      t = if mod_name == mn then task_name else defaultTaskName

      memo.push {
        env_name: modules[mn].env_name
        mod_name: modules[mn].mod_name
        task_name: t
      }

      memo

  buildDependenciesEmCList: (env_name, mod_name) ->
    modules     = {}
    modulesList = []

    @_resolveDependencies(env_name, mod_name, modules, modulesList, [], false)

    @_.map modulesList, (mn) => modules[mn]


  # ----------------------------------------------------------
  # private

  # @nodoc
  _resolveDependencies: (env_name, mod_name, mods, depList, modsChecked, returnIfCached = true) ->
    # cached check
    cached    = if /^cached\:/.test(mod_name) then true else false
    mod_name  = mod_name.replace(/^cached\:/, '') if cached
    emc       = @getEmc(env_name, mod_name) || {}
    buildInfo = @getCache().getBuildInfo(emc)

    # skip if cached and valid
    if cached && buildInfo.built == true && returnIfCached == true
      built_at = new Date(buildInfo.built_at)
      @g.log.writeln ''
      @g.log.ok "Cached task (built at #{built_at}):"
      @g.log.ok ">>> '#{env_name}:#{mod_name}'"
      return

    # ensure data
    mods[mod_name] or= emc

    # check dependencies
    unless @_.includes(modsChecked, mod_name)
      modsChecked.push mod_name

      # get and ensure emc
      @g.fail.fatal("Graspi: Could not resolve dependency - #{mod_name}") unless @_.isObject(emc.emc)

      # resolve dependencies
      @_.each (emc.emc.dependencies || []), (dep_mod_name) =>
        @_resolveDependencies(env_name, dep_mod_name, mods, depList, modsChecked, returnIfCached)

      # add to list
      depList.push mod_name


