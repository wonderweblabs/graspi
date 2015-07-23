Crypto              = require('crypto')
Fs                  = require('fs')
File                = require('path')
Convert             = require('convert-source-map')

module.exports = class TaskHelper extends require('./abstract')

  isEnabled: ->
    return false unless super() == true

    @getConfig().filerevision.enabled == true

  run: ->
    @mappingUpdatable = false

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
    @getConfig().filerevision.manifest.prettyPrint

  getCssBasePaths: ->
    return [] unless @_.isObject(@getAppConfig().css)

    p = "#{@getAppConfig().css.destPath}/#{@getAppConfig().css.destFile}"
    if @g.file.exists(p) then [File.dirname(p)] else []

  getJsBasePaths: ->
    return [] unless @_.isObject(@getAppConfig().js)

    p = "#{@getAppConfig().js.destPath}/#{@getAppConfig().js.destFile}"
    if @g.file.exists(p) then [File.dirname(p)] else []

  getImagesBasePaths: ->
    return [] unless @_.isObject(@getAppConfig().images)

    [File.join(@getAppConfig().images.destPath, @getAppConfig().images.destFolder)]

  getBasePaths: ->
    return @_basePaths unless @_.isEmpty(@_basePaths)

    @_basePaths = [
      @getCssBasePaths(),
      @getCssBasePaths(),
      @getImagesBasePaths()
    ]

    @_basePaths = @_.uniq(@_.flatten(@_basePaths))
    @_basePaths

  # -----

  collectFilesInBasePaths: ->
    @_.inject @getBasePaths(), [], (memo, path) =>
      memo = memo.concat(@g.file.expand(File.join(path, '{,*/}*')))
      memo

  filterRevisionedFiles: (files) ->
    @_.filter files, (path) =>
      @getRevisionedFileRegex().test(path) == false

  filterChangedFiles: (files) ->
    @_.filter files, (path) => @fileCacheHasChanged(path)

  dropOldRevisionFiles: (files) ->
    return unless @isEnabled() == true

    @_.each files, (path) =>
      f = @getMapping()[path]
      @g.file.delete(f) if f && f != path && @g.file.exists(f)

  createRevisionFiles: (files) ->
    @_.each files, (path) =>
      if @isEnabled() == true
        newPath = @_digestPath(path)
        @g.file.copy(path, newPath)
      else
        newPath = path

      @getMapping()[path] = newPath

  updateSourceMapLink: (files) ->
    @_.each files, (path) =>
      sourceMapPath   = "#{path}.map"
      resultFilePath  = @getMapping()[path]

      return unless @g.file.exists(resultFilePath)
      return unless @g.file.exists(sourceMapPath)

      fileContents  = @g.file.read(resultFilePath, {encoding: 'utf8'})
      matches       = Convert.mapFileCommentRegex.exec(fileContents)

      return unless matches

      sourceMapFile = matches[1] || matches[2]
      newSrcMap     = fileContents.replace sourceMapFile, File.basename(sourceMapPath)

      @g.file.write resultFilePath, newSrcMap, {encoding: 'utf8'}


  updateFileChangeTimestamps: (files) ->
    @_.each files, (path) => @fileCacheUpdate(path)


  # ----------------------------------------------------------
  # private

  # @nodoc
  _readMappingFile: ->
    return {} unless @g.file.exists(@getMappingFilePath())

    try
      @_mapping = @g.file.readJSON(@getMappingFilePath())
    catch e
      @_mapping = {}

    @_mapping or= {}
    @_mapping

  # @nodoc
  _writeMappingFile: ->
    spaces = if @getMappingFilePrettyPrint() == true then 4 else 0
    mapping = JSON.stringify(@_mapping, null, spaces)

    @g.file.write @getMappingFilePath(), mapping, { encoding: 'utf-8' }

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
