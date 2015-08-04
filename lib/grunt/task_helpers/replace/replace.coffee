_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'replace'

  gruntTaskTargetAppendix: 'graspi-replace-replace'

  cacheKeyAppendix: 'replace-replace'

  cached: -> @getConfig().replace.replace.cached == true

  enabled: -> super() && _.isArray(@getAppConfig().replace)

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    _.each @getAppConfig().replace, (replaceConfig, index) =>
      replaceConfig.cid = index
      target = "#{@getGruntTaskTarget()}-#{replaceConfig.cid}"
      target = target.replace(/(\.|\:)/g, '-')

      @g.config.set("#{@getGruntTask()}.#{target}", @buildConfig(replaceConfig))
      @g.task.run "#{@getGruntTask()}:#{target}"

  buildConfig: (replaceConfig) ->
    cfg                   = {}
    cfg.options           = {}
    cfg.options.patterns  = []

    cfg.options.patterns.push
      match: @getPatternPattern(replaceConfig)
      replacement: @getPatternReplace(replaceConfig)

    cfg.files = []
    cfg.files.push
      expand: true
      src:    @getFiles(replaceConfig)
      filter: (file) => @fileCacheUpdateIfChanged(file, "#{@getCacheKey()}-#{replaceConfig.cid}")

    cfg

  getFiles: (replaceConfig) ->
    replaceConfig.files

  getPatternReplace: (replaceConfig) ->
    if _.isArray(replaceConfig.replace)
      entries = _.map replaceConfig.replace, (replaceEntry) =>
        if _.isObject(replaceEntry) && _.isString(replaceEntry.file)
          @g.file.read(replaceEntry.file)
        else
          replaceEntry
      entries.join('\n')
    else
      replaceConfig.replace

  getPatternPattern: (replaceConfig) ->
    pattern = @_normalizePattern(replaceConfig.pattern)

    new RegExp(pattern.pattern, pattern.modifiers)

  # ----------------------------------------------------------
  # private

  # @nodoc
  _normalizePattern: (pattern) ->
    if _.isString(pattern.quotesPlaceholder)
      regex = new RegExp("(#{pattern.quotesPlaceholder})", 'g')
      pattern.pattern = pattern.pattern.replace(regex, '\\\'')

    if _.isString(pattern.doubleQuotesPlaceholder)
      regex = new RegExp("(#{pattern.doubleQuotesPlaceholder})", 'g')
      pattern.pattern = pattern.pattern.replace(regex, '\\\"')

    pattern


