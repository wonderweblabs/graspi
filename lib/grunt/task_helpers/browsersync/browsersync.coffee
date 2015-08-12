_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'browserSync'

  gruntTaskTargetAppendix: 'graspi-browsersync'

  cacheKeyAppendix: 'css-browsersync'

  cached: false

  enabled: ->
    super() &&
    _.isArray(@getConfig().live.browserSync.bsFiles) &&
    _.size(@getConfig().live.browserSync.bsFiles) > 0

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    @grunt.config.set(@getGruntTask(), @buildConfig())
    @grunt.task.run @getGruntTask()

  buildConfig: ->
    cfg = @grunt.config.get('browserSync') || {}
    cfg.options or= {}
    cfg.bsFiles or= []

    cfg.options = _.merge {}, cfg.options, @buildBaseOptions()
    cfg.bsFiles = _.uniq(cfg.bsFiles.concat(@buildSrcArray()))

    cfg

  buildBaseOptions: ->
    _.inject @getConfig().live.browserSync.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

  buildSrcArray: ->
    @getConfig().live.browserSync.bsFiles || []