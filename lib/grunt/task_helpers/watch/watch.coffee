_ = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'watch'

  gruntTaskTargetAppendix: 'graspi-watch'

  enabled: -> _.isObject(@getConfig().live.watch.groups)

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    @grunt.config.set(@getGruntTask(), @buildConfig())
    @grunt.task.run @getGruntTask()

  buildConfig: ->
    watchConfig = _.inject @getConfig().live.watch.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg         = {}
    cfg.options = watchConfig
    cfg.files   = []

    _.each @getConfig().live.watch.groups, (group, group_name) =>
      group_name = "#{@getEnvName()}-#{@getModName()}-#{group_name}"

      cfg[group_name]         = {}
      cfg[group_name].options = watchConfig
      cfg[group_name].files   = group.files
      cfg[group_name].tasks   = _.map group.tasks, (task) =>
        "graspi_live_watch:#{@getEnvName()}:#{@getModName()}:#{task}"

    cfg