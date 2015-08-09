_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'replace'

  gruntTaskTargetAppendix: 'graspi-css-polymer_mixin_replace'

  cacheKeyAppendix: 'css-polymer_mixin_replace'

  cached: -> @getConfig().css.polymerMixinReplace.cached == true

  isCacheValid: ->
    !@fileCacheHasChanged(@getDestFile())


  # ------------------------------------------------------------

  buildConfig: (replaceConfig) ->
    self = @

    cfg                   = {}
    cfg.options           = {}
    cfg.options.patterns  = []

    cfg.options.patterns.push
      match: @_placeholderSearchRegex()
      replacement: (match) =>
        self._matchReplace(match)

    cfg.files = []
    cfg.files.push
      expand: true
      src:    [@getDestFile()]

    cfg

  # ----------------------------------------------------------
  # private

  # @nodoc
  _matchReplace: (match) ->
    placeholder = /(?:\/\*)(?:\sPOLYMER-MIXIN\s)(.*)(?:\s?\*\/)/g.exec(match)
    placeholder = if _.isArray(placeholder) then (placeholder[1] || null) else null
    return match if placeholder == null

    file = @getDestFile()
    mixin = @_getPolymerMixinRegex(placeholder).exec(@g.file.read(file) || '')
    mixin = mixin[1] if _.isArray(mixin)
    return match unless _.isString(mixin) && _.size(mixin) > 0

    result = "#{placeholder.replace(/(\s*)?$/, '')}: {"
    result += mixin
    result += '};'
    result += 'display: ' + placeholder.replace(/(\s*)?$/, '') + ';'

    result

  # @nodoc
  _placeholderSearchRegex: ->
    /(?:\/\*)(?:\sPOLYMER-MIXIN\s)(\S*)(?:\s?\*\/)/gm

  # @nodoc
  _getPolymerMixinRegex: (mixinName) ->
    new RegExp("#{mixinName}[\\s*]?\\{([^\\{][\\s\\S][^\\}]*)", 'gm')
