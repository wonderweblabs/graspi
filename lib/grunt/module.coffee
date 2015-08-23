_     = require 'lodash'
Task  = require './task'

module.exports = class Module

  #
  # Options:
  #   * env_name
  #   * mod_name
  #   * built           **[true/false]
  #   * built_at        **[0|timestamp]
  #
  # ** = existing options, but ignored, if you pass them into the constructor
  #
  constructor: (@grunt, @options) ->
    @_checkOptions()
    @_prepareData()
    @_buildDependencies()

  #
  # Mainly to filter the grunt object
  #
  toString: ->
    _.omit(@, 'grunt')

  #
  # Environment
  #
  getEnvName: ->
    @options.env_name

  #
  # Module
  #
  getModName: ->
    @options.mod_name

  #
  # Env + mod
  #
  getEMName: ->
    "#{@getEnvName()}-#{@getModName()}"

  #
  # EMC
  #
  getEmc: ->
    @options.emc

  #
  # Config
  #
  getEmcConfig: ->
    @getEmc().emc

  #
  # Config options
  #
  getEmcOptions: ->
    @getEmcConfig().options || {}

  #
  # If has been built
  #
  isBuilt: (task_name) ->
    @_checkIfIsBuiltForTask(task_name) == true

  #
  # Include dependencies (for tasks)
  #
  areDependenciesIncluded: ->
    @getEmc().includeDependencies == true

  #
  # Returns the array of dependencies
  #
  getDependencies: ->
    (@_dependencies || [])

  #
  # Return resolved dependencies tree
  #
  resolveDependencyTree: (modules = [], modsChecked = [], includeSelf = true) ->
    return modules if _.includes modsChecked, @getEMName()

    modsChecked.push @getEMName()

    modules = modules.concat @_resolveDependencies(modules, modsChecked)
    modules = modules.concat @ if includeSelf == true

    modules

  #
  # Build tasks list
  #
  getTaskList: (task_name) ->
    (new Task(@grunt, @getEmc(), task_name)).resolve()

  #
  #
  #
  updateBuildInfo: (task_name) ->
    @_updateBuildInfo(task_name)


  # ----------------------------------------------------------
  # private

  # @nodoc
  _checkOptions: ->
    unless _.isString(@options.env_name)
      @grunt.fail.fatal('Module: options.env_name missing.', @options)

    unless _.isString(@options.mod_name)
      @grunt.fail.fatal('Module: options.mod_name missing.', @options)

  # @nodoc
  _prepareData: ->
    @options.emc or= @grunt.graspi.config.getEmc(@getEnvName(), @getModName())

    # dependencies
    @_dependencies = []

  # @nodoc
  _checkIfIsBuiltForTask: (task_name) ->
    tracker = @grunt.graspi.config.getBuildCacheTracker(@getEmc())

    info = tracker.getBuildInfo(@getEmc(), task_name)

    info.built

  # @nodoc
  _updateBuildInfo: (task_name) ->
    tracker = @grunt.graspi.config.getBuildCacheTracker(@getEmc())

    tracker.setBuildCache(@getEmc(), task_name)

  # @nodoc
  _buildDependencies: ->
    if _.isEmpty(@getEmc()) || _.isEmpty(@getEmc().emc)
      @grunt.fail.fatal "Missing config for module #{@getModName()} in env #{@getEnvName()}"

    @_dependencies = _.map (@getEmc().emc.dependencies || []), (mod_name) =>
      @grunt.graspi.config.getModule(@getEnvName(), mod_name)

  # @nodoc
  _resolveDependencies: (modules, modsChecked) ->
    _.inject @getDependencies(), [], (memo, module) =>
      memo.concat(module.resolveDependencyTree(modules, modsChecked, true) || [])



