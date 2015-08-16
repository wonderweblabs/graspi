_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'replace'

  gruntTaskTargetAppendix: 'graspi-replace-replace'

  cacheKeyAppendix: 'replace-replace'

  cached: -> @getConfig().replace.replace.cached == true

  enabled: -> super() && _.isArray(@getAppConfig().replace)

  isCacheValid: ->
    !_.any @getAppConfig().replace, (replaceConfig, index) =>
      _.any @getFiles(replaceConfig), (f) =>
          @fileCacheHasChanged(f, "#{@getCacheKey()}-#{index}")

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    _.each @getAppConfig().replace, (replaceConfig, index) =>
      replaceConfig.cid = index

      target = "#{@getGruntTaskTarget()}-#{replaceConfig.cid}"
      target = target.replace(/(\.|\:)/g, '-')

      @grunt.config.set("#{@getGruntTask()}.#{target}", @buildConfig(replaceConfig))
      @grunt.task.run "#{@getGruntTask()}:#{target}"

  buildConfig: (replaceConfig) ->
    config = _.inject @getConfig().replace.replace.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    cfg                   = {}
    cfg.options           = config
    cfg.options.patterns  = []

    cfg.options.patterns.push
      match: @getPatternPattern(replaceConfig)
      replacement: @getPatternReplace(replaceConfig)

    cfg.files = []
    cfg.files.push
      expand: true
      src:    @getFiles(replaceConfig)

    cfg

  getFiles: (replaceConfig) ->
    _.map (replaceConfig.files || []), (file) => @replacePlaceholders(file)

  replacePlaceholders: (str = '') ->
    results = _.uniq(str.match(/\%\%[a-zA-Z0-9]*\%\%/g) || [])
    mapping = @getPlaceholderMapping()

    _.each results, (result) =>
      repl = mapping[result.replace(/\%/g, '')]
      return unless _.isString(repl)

      str = str.replace(new RegExp(result, 'g'), repl)

    str

  getPlaceholderMapping: ->
    envName:      @getEnvName()
    modName:      @getModName()
    taskName:     @getTaskName()
    destBasePath: @getDestBasePath()
    destPath:     @getDestPath()
    destFolder:   @getDestFolder()
    tmpPath:      @getTmpPath()
    basePath:     @getBasePath()

  getPatternReplace: (replaceConfig) ->
    if _.isString(replaceConfig.replace)
      return @replacePlaceholders(replaceConfig.replace)

    else if _.isArray(replaceConfig.replace)
      entries = _.map replaceConfig.replace, (replaceEntry) =>
        if _.isObject(replaceEntry) && _.isString(replaceEntry.file)
          @grunt.file.read(@replacePlaceholders(replaceEntry.file))
        else
          @replacePlaceholders(replaceEntry)

      return entries.join('\n')

    else if _.isObject(replaceConfig.replace) && replaceConfig.replace.type == 'self'
      prepend = replaceConfig.replace.prepend || ''
      append = replaceConfig.replace.append || ''

      prepend = '\n\r' if prepend == 'NEWLINE'
      append = '\n\r' if append == 'NEWLINE'

      func = (match) ->
        match = @replacePlaceholders(match || '')

        "#{prepend}#{match}#{append}"

      return func

    else
      return replaceConfig.replace

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


