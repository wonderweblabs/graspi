_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'concat_sourcemap'

  gruntTaskTargetAppendix: 'graspi-js-copy'

  cacheKeyAppendix: 'js-copy'

  cached: -> @getConfig().js.copy.cached == true

  enabled: -> super() && _.size(@getJsFiles()) > 0

  isCacheValid: ->
    _.inject @getJsFiles(), true, (memo, file) =>
      return false if memo == false

      file = File.join(@getBasePath(), file)
      return !@fileCacheHasChanged(file) if @grunt.file.isFile(file)

      _.inject @grunt.file.expand(file), true, (subMemo, subFile) =>
        if subMemo == false then false else !@fileCacheHasChanged(subFile)

  # ------------------------------------------------------------

  getJsFiles: ->
    @_jsFiles or= _.inject (@getAppConfig().js.files || []), [], (memo, file) =>
      memo.push file if /\.js$/.test(file)
      memo

  buildConfig: ->
    cfg                        = {}
    cfg.options                = {}
    cfg.options.sourcesContent = false
    cfg.files                  = [{
      expand: true
      src:    @getJsFiles()
      cwd:    File.join(@getBasePath(), '/')
      dest:   File.join(@getTmpPath(), '/')
      filter: (file) =>
        if @fileCacheHasChanged(file)
          resultFile = file.replace(@getBasePath(), '')
          resultFile = File.join(@getTmpPath(), resultFile)
          @grunt.file.delete(resultFile, { force: true }) if @grunt.file.exists(resultFile)

          @fileCacheUpdate(file)
          true
        else
          false
    }]

    cfg