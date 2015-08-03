_         = require 'lodash'
File      = require 'path'
JsonFile  = require '../../util/json_file'

module.exports = class TaskHelper extends require('./abstract')

  cached: -> @getConfig().postpipeline.manifest.cached == true

  isCacheValid: ->
    @g.file.exists(@getManifestFile()) &&
    !@fileCacheHasChanged(@getMappingFile())

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false
    return if @isCached() && @isCacheValid()

    @_readManifestFile()

    mapping = _.merge {}, @getMapping()
    mapping = @parseMapping(mapping)
    mapping = @parseMappingWithPattern(mapping)

    @updateManifest(mapping)

    @_writeManifestFile()


  # -----

  getJsonFile: ->
    @_jsonFile or= JsonFile(@g)

  getManifest: ->
    @_manifest or= @_readManifestFile()

  getManifestFilePrettyPrint: ->
    @getConfig().postpipeline.manifest.options.mappingPrettyPrint

  getManifestReplacePattern: ->
    @getConfig().postpipeline.manifest.replacePattern

  getMapping: ->
    @_mapping or= @_readMappingFile()

  # -----

  parseMapping: (mapping) ->
    _.inject mapping, {}, (memo, resultPath, path) =>
      pathNew = path.replace(@getAppConfig().destPath, '')
      pathNew = File.join(@getModName(), pathNew)

      return memo if _.isEmpty(pathNew)

      pathNew = pathNew.replace(/^(\/)?/, '')

      memo[pathNew] = resultPath
      memo

  parseMappingWithPattern: (mapping) ->
    return mapping unless _.isObject(@getManifestReplacePattern())
    return mapping if _.isEmpty(@getManifestReplacePattern().pattern)

    pattern = new RegExp(@getManifestReplacePattern().pattern, 'g')
    replace = @getManifestReplacePattern().replace || ''

    _.inject mapping, {}, (memo, resultPath, path) =>
      memo[path] = resultPath.replace(pattern, replace)
      memo

  updateManifest: (mapping) ->
    _.each mapping, (resultPath, path) =>
      @getManifest()[path] = resultPath

    @fileCacheUpdate(@getMappingFile())


  # ----------------------------------------------------------
  # private

  # @nodoc
  _readManifestFile: ->
    @_originalManifest = @getJsonFile().read(@getManifestFile())

    @_manifest = @_originalManifest[@getEnvName()]
    @_manifest or= {}

    @_manifest

  # @nodoc
  _readMappingFile: ->
    @_mapping = @getJsonFile().read(@getMappingFile())

  # @nodoc
  _writeManifestFile: ->
    @_originalManifest or= {}
    @_originalManifest[@getEnvName()] or= {}
    @_originalManifest[@getEnvName()] = _.merge {}, @_originalManifest[@getEnvName()], @_manifest

    @getJsonFile().write(@getManifestFile(), @_originalManifest)



