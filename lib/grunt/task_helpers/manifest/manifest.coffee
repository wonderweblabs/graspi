Crypto              = require('crypto')
Fs                  = require('fs')
File                = require('path')
Convert             = require('convert-source-map')

module.exports = class TaskHelper extends require('./abstract')

  isEnabled: ->
    return false unless super() == true

    @getConfig().manifest.enabled == true

  run: ->
    return unless @isEnabled() == true
    return unless !@g.file.exists(@getManifestFilePath()) || @fileCacheHasChanged(@getMappingFilePath())

    @mappingUpdatable  = false

    @_readManifestFile()

    mapping = @_.merge {}, @getMapping()
    mapping = @parseMapping(mapping)
    mapping = @parseMappingWithPattern(mapping)

    @updateManifest(mapping)

    @_writeManifestFile()


  # -----

  getManifest: ->
    @_manifest or= @_readManifestFile()

  getManifestFilePrettyPrint: ->
    @getConfig().manifest.prettyPrint

  getManifestReplacePattern: ->
    @getConfig().manifest.pathReplacePattern

  getMapping: ->
    @_mapping or= @_readMappingFile()

  # -----

  parseMapping: (mapping) ->
    destPaths = []

    destPaths.push @getAppConfig().css.destPath if @_.isObject(@getAppConfig().css)
    destPaths.push @getAppConfig().js.destPath if @_.isObject(@getAppConfig().js)
    destPaths.push @getAppConfig().images.destPath if @_.isObject(@getAppConfig().images)

    destPaths = @_.uniq(destPaths)

    @_.inject mapping, {}, (memo, resultPath, path) =>
      pathNew = null

      @_.each destPaths, (destPath) =>
        pathNew = path.replace(destPath, '')

      return memo if @_.isEmpty(pathNew)

      pathNew = pathNew.replace(/^(\/)?/, '')

      memo[pathNew] = resultPath
      memo

  parseMappingWithPattern: (mapping) ->
    return mapping unless @_.isObject(@getManifestReplacePattern())

    return mapping if @_.isEmpty(@getManifestReplacePattern().pattern)

    pattern = new RegExp(@getManifestReplacePattern().pattern, 'g')
    replace = @getManifestReplacePattern().replace || ''

    @_.inject mapping, {}, (memo, resultPath, path) =>
      memo[path] = resultPath.replace(pattern, replace)
      memo

  updateManifest: (mapping) ->
    @_.each mapping, (resultPath, path) =>
      @getManifest()[path] = resultPath

    @fileCacheUpdate(@getMappingFilePath())


  # ----------------------------------------------------------
  # private

  # @nodoc
  _readManifestFile: ->
    return {} unless @g.file.exists(@getManifestFilePath())

    try
      @_originalManifest = @g.file.readJSON(@getManifestFilePath())
    @_originalManifest or= {}

    @_manifest = @_originalManifest[@eac.env_name]
    @_manifest or= {}

    @_manifest

  # @nodoc
  _readMappingFile: ->
    return {} unless @g.file.exists(@getMappingFilePath())

    try
      @_mapping = @g.file.readJSON(@getMappingFilePath())
    @_mapping or= {}

    @_mapping

  # @nodoc
  _writeManifestFile: ->
    @_originalManifest or= {}
    @_originalManifest[@eac.env_name] or= {}
    @_originalManifest[@eac.env_name] = @_.merge {}, @_originalManifest[@eac.env_name], @_manifest

    spaces = if @getManifestFilePrettyPrint() == true then 4 else 0
    mapping = JSON.stringify(@_originalManifest, null, spaces)

    @g.file.write @getManifestFilePath(), mapping, { encoding: 'utf-8' }



