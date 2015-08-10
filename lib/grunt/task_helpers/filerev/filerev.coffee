_       = require 'lodash'
Crypto  = require('crypto')
Fs      = require('fs')
File    = require('path')
Convert = require('convert-source-map')

module.exports = class TaskHelper extends require('./abstract')

  cached: -> @getConfig().postpipeline.filerevision.cached == true

  withDigest: -> @getConfig().postpipeline.filerevision.digest == true

  # ------------------------------------------------------------

  run: ->
    return if @isEnabled() == false

    @_readMappingFile()

    files = @collectFilesInBasePaths()
    files = @filterRevisionedFiles(files)
    files = @filterChangedFiles(files)

    @dropOldRevisionFiles(files)
    @createRevisionFiles(files)
    @updateSourceMapLink(files)
    @updateFileChangeTimestamps(files)

    @_writeMappingFile()

  # -----

  getHashLength: ->
    @_hashLength or= 64

  getRevisionedFileRegex: ->
    @_revisionedFileRegex or= new RegExp("\.[a-zA-Z0-9]{#{@getHashLength()}}\.")

  getMapping: ->
    @_mapping or= @_readMappingFile()

  getMappingFilePrettyPrint: ->
    @getConfig().postpipeline.filerevision.options.mappingPrettyPrint

  # -----

  collectFilesInBasePaths: ->
    @grunt.file.expand(File.join(@getDestPath(), '**/*'))

  filterRevisionedFiles: (files) ->
    _.filter files, (path) =>
      @getRevisionedFileRegex().test(path) == false

  filterChangedFiles: (files) ->
    _.filter files, (path) => @fileCacheHasChanged(path)

  dropOldRevisionFiles: (files) ->
    return unless @withDigest() == true

    _.each files, (path) =>
      f = @getMapping()[path]
      @grunt.file.delete(f) if f && f != path && @grunt.file.exists(f)

  createRevisionFiles: (files) ->
    _.each files, (path) =>
      if @withDigest() == true
        newPath = @_digestPath(path)
        @grunt.file.copy(path, newPath)
      else
        newPath = path

      @getMapping()[path] = newPath

  updateSourceMapLink: (files) ->
    _.each files, (path) =>
      sourceMapPath   = "#{path}.map"
      resultFilePath  = @getMapping()[path]

      return unless @grunt.file.exists(resultFilePath)
      return unless @grunt.file.exists(sourceMapPath)

      fileContents  = @grunt.file.read(resultFilePath, {encoding: 'utf8'})
      matches       = Convert.mapFileCommentRegex.exec(fileContents)

      return unless matches

      sourceMapFile = matches[1] || matches[2]
      newSrcMap     = fileContents.replace sourceMapFile, File.basename(sourceMapPath)

      @grunt.file.write resultFilePath, newSrcMap, {encoding: 'utf8'}


  updateFileChangeTimestamps: (files) ->
    _.each files, (path) => @fileCacheUpdate(path)


  # ----------------------------------------------------------
  # private

  # @nodoc
  _readMappingFile: ->
    return {} unless @grunt.file.exists(@getMappingFile())

    try
      @_mapping = @grunt.file.readJSON(@getMappingFile())
    catch e
      @_mapping = {}

    @_mapping or= {}
    @_mapping

  # @nodoc
  _writeMappingFile: ->
    spaces = if @getMappingFilePrettyPrint() == true then 4 else 0
    mapping = JSON.stringify(@_mapping, null, spaces)

    @grunt.file.write @getMappingFile(), mapping, { encoding: 'utf-8' }

  # @nodoc
  _digestPath: (path) ->
    hash = Crypto.createHash('sha256').update(Fs.readFileSync(path)).digest('hex')
    hash = hash.slice(0, 64)

    fileData = File.parse(path)

    if /(css\.map)$/.test(path)
      newFileName = path.replace(/css\.map$/, '')
      newFileName += "#{hash}.css.map"
      return newFileName
    else if /(js\.map)$/.test(path)
      newFileName = path.replace(/js\.map$/, '')
      newFileName += "#{hash}.js.map"
      return newFileName
    else
      newFileName = "#{fileData.name}.#{hash}#{fileData.ext}"
      return File.join(fileData.dir, newFileName)
