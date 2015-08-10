_     = require 'lodash'
Cache = require('./cache')

module.exports = class Dependencies

  constructor: (@grunt) ->
    @_modules       = []
    @_moduleOptions = {}

  getConfig: ->
    @grunt.graspi.config

  getEmc: (env_name, mod_name) ->
    @getConfig().getEmc(env_name, mod_name)

  getCache: ->
    @_cache or= new Cache(@grunt)

  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * main_task_name
  # * resolveDeps [null/true/false]
  # * depsTask
  # * depsCaching [null/true/false]
  #
  # Returns ordered list of task options. Each option hash contains following
  # values:
  # * cached
  # * emc
  # * env_name
  # * mod_name
  # * task_name
  # * main_task_name
  # * resolveDeps
  # * depsTask
  # * depsCaching
  #
  buildExecutionList: (options) ->
    @_modules       = []
    @_moduleOptions = {}

    options             = _.clone(options)
    options.cached      = options.depsCaching
    options.emc         = null
    options.task_name or= options.depsTask
    options.task_name or= options.main_task_name

    @_moduleOptions[options.mod_name] = options

    @_resolveDependencies(options, [])

    _.map @_modules, (mod_name) =>
      module = _.clone(@_moduleOptions[mod_name])
      module.resolveDeps = false
      module

  #
  # Options:
  # * env_name (req)
  # * mod_name (req)
  # * task_name
  # * main_task_name
  # * resolveDeps [null/true/false]
  # * depsTask
  # * depsCaching [null/true/false]
  #
  # Returns ordered list of emc objects.
  #
  buildDependenciesEmcList: (options) ->
    options = _.merge options, { resolveDeps: true, cached: false, depsCaching: false }
    runList = @buildExecutionList(options)

    _.map runList, (moduleOptions) -> moduleOptions.emc


  # ----------------------------------------------------------
  # private

  # @nodoc
  _resolveDependencies: (taskOptions, modsChecked) ->
    taskOptions = _.clone(taskOptions)

    # cached check
    cached    = if /^cached\:/.test(taskOptions.mod_name) then true else false
    cached    = taskOptions.cached if _.isBoolean(taskOptions.cached)
    env_name  = taskOptions.env_name
    mod_name  = taskOptions.mod_name.replace(/^cached\:/, '')
    emc       = @getEmc(env_name, mod_name) || {}
    buildInfo = @getCache().getBuildInfo(emc)

    # skip if cached and valid
    if cached && buildInfo.built == true && cached == true
      built_at = new Date(buildInfo.built_at)
      @grunt.log.writeln ''
      @grunt.log.ok "Cached task (built at #{built_at}):"
      @grunt.log.ok ">>> '#{env_name}:#{mod_name}'"
      return

    # ensure data
    @_moduleOptions[mod_name] or= {}
    @_moduleOptions[mod_name].cached          = cached unless _.isBoolean(@_moduleOptions[mod_name].cached)
    @_moduleOptions[mod_name].emc             or= emc
    @_moduleOptions[mod_name].env_name        or= env_name
    @_moduleOptions[mod_name].mod_name        or= mod_name
    @_moduleOptions[mod_name].task_name       or= taskOptions.task_name
    @_moduleOptions[mod_name].main_task_name  or= taskOptions.main_task_name
    @_moduleOptions[mod_name].resolveDeps     or= taskOptions.resolveDeps
    @_moduleOptions[mod_name].depsTask        or= taskOptions.depsTask

    unless _.isBoolean(@_moduleOptions[mod_name].depsCaching)
      if _.isBoolean(taskOptions.cached)
        @_moduleOptions[mod_name].depsCaching = taskOptions.cached
      else
        @_moduleOptions[mod_name].depsCaching = null

    # check dependencies
    unless _.includes(modsChecked, mod_name)
      modsChecked.push mod_name

      # get and ensure emc
      unless _.isObject(emc.emc)
        @grunt.fail.fatal("Graspi: Could not resolve dependency - #{mod_name}")

      # resolve dependencies
      unless @_moduleOptions[mod_name].resolveDeps == false
        _.each (emc.emc.dependencies || []), (dep_mod_name) =>
          @_resolveDependencies({
              cached:         @_moduleOptions[mod_name].depsCaching
              env_name:       @_moduleOptions[mod_name].env_name
              mod_name:       dep_mod_name
              task_name:      @_moduleOptions[mod_name].depsTask
              main_task_name: @_moduleOptions[mod_name].main_task_name
              resolveDeps:    @_moduleOptions[mod_name].resolveDeps
              depsTask:       @_moduleOptions[mod_name].depsTask
              depsCaching:    @_moduleOptions[mod_name].depsCaching
            }, modsChecked)

      # add to list
      @_modules.push mod_name


