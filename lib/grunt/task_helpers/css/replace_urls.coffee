_         = require 'lodash'
File      = require 'path'
JsonFile  = require '../../util/json_file'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'replace'

  gruntTaskTargetAppendix: 'graspi-css-replace_urls'

  cacheKeyAppendix: 'css-replace_urls'

  cached: -> @getConfig().postpipeline.urlReplace.cached == true

  isCacheValid: ->
    !@fileCacheHasChanged(@getDestFilePath())

  # ------------------------------------------------------------

  getJsonFile: ->
    @_jsonFile or= JsonFile(@g)

  getManifestMapping: ->
    mapping = @getJsonFile().read(@getConfig().postpipeline.manifest.options.path)

    mapping[@getEnvName()] || {}

  getAssetHost: ->
    host = @getConfig().postpipeline.urlReplace.options.assetHost

    return '' if host == 'undefined' || host == undefined
    return '' if host == 'null' || host == null

    host

  getPatterns: ->
    patterns = @getConfig().postpipeline.urlReplace.options.cssPatterns

    @_normalizePatterns(patterns)

  buildConfig: ->
    mapping   = @getManifestMapping()
    patterns  = @getPatterns()

    cfg                   = {}
    cfg.options           = {}
    cfg.options.patterns  = []

    _.each patterns, (pattern) =>
      p       = {}
      p.match = new RegExp(pattern.pattern, pattern.pattern.modifiers)
      p.replacement = (match) =>
        match   = match[0] if _.isArray(match)
        result  = match.match(new RegExp(pattern.pattern))
        file    = result[1] if _.isArray(result) && _.isString(result[1])

        return match if _.isEmpty(mapping[file])
        return "url('/#{mapping[file]}')" if _.isEmpty(@getAssetHost())

        host = @getAssetHost().replace(/\/$/, '')

        "url('#{host}/#{mapping[file]}')"

      cfg.options.patterns.push p

    cfg.files = []
    cfg.files.push {
      expand: true
      src: [@getDestFilePath()]
    }

    cfg

  # ----------------------------------------------------------
  # private

  # @nodoc
  _normalizePatterns: (patterns) ->
    _.map patterns, (pattern) => @_normalizePattern(pattern)

  # @nodoc
  _normalizePattern: (pattern) ->
    if _.isString(pattern.quotesPlaceholder)
      regex = new RegExp("(#{pattern.quotesPlaceholder})", 'g')
      pattern.pattern = pattern.pattern.replace(regex, '\\\'')

    if _.isString(pattern.doubleQuotesPlaceholder)
      regex = new RegExp("(#{pattern.doubleQuotesPlaceholder})", 'g')
      pattern.pattern = pattern.pattern.replace(regex, '\\\"')

    pattern




