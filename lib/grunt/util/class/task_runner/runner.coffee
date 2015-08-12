_ = require 'lodash'

module.exports = class Runner

  constructor: (@grunt, @taskRunner) ->

  getConfig: ->
    @grunt.graspi.config

  getTaskRunner: ->
    @taskRunner

  getEmc: (env_name, mod_name) ->
    @getConfig().getEmc(env_name, mod_name)

  #
  # Takes array of objects with values:
  # * env_name
  # * mod_name
  # * task_name
  # * main_task_name
  # * resolveDeps
  # * depsTask
  # * depsCaching
  #
  runTasks: (runList) ->
    _.each runList, (runListEntry) => @runGruntTask(runListEntry)

  #
  # Takes object with values:
  # * env_name
  # * mod_name
  # * task_name
  # * main_task_name
  # * resolveDeps
  # * depsTask
  # * depsCaching
  #
  runGruntTask: (options) ->
    task_name = options.task_name.replace(/^graspi\_/, '')
    mod_name  = options.mod_name

    @grunt.option "#{mod_name}_env_name",       options.env_name
    @grunt.option "#{mod_name}_mod_name",       options.mod_name
    @grunt.option "#{mod_name}_task_name",      options.task_name
    @grunt.option "#{mod_name}_main_task_name", options.main_task_name
    @grunt.option "#{mod_name}_resolveDeps",    options.resolveDeps
    @grunt.option "#{mod_name}_depsTask",       options.depsTask
    @grunt.option "#{mod_name}_depsCaching",    options.depsCaching
    @grunt.option "#{mod_name}_cached",         options.cached
    @grunt.option "#{mod_name}_emc",            options.emc

    cfg             = {}
    cfg["graspi_#{task_name}"]  = {}

    @grunt.config.merge cfg
    @grunt.task.run "graspi_#{task_name}:#{options.env_name}:#{mod_name}"
