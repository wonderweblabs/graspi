_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'svgmin'

  gruntTaskTargetAppendix: 'graspi-images-svgmin'

  cacheKeyAppendix: 'images-svgmin'

  cached: -> @getConfig().images.imagemin.cached == true

  isCacheValid: ->
    _.inject @getImagesFiles(), true, (memo, file) =>
      return false if memo == false

      !@fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getImagesFiles: ->
    return @_imageFiles if _.isArray(@_imageFiles)

    @_imageFiles = []

    _.each @getConfig().images.imagemin.formats.svg, (format) =>
      path = File.join(@getDestPath(), "**/*.#{format}")
      files = @g.file.expand(path)

      @_imageFiles = @_imageFiles.concat(files) if _.isArray(files)

    @_imageFiles = _.uniq(@_imageFiles)
    @_imageFiles

  buildConfig: ->
    cfg             = {}
    cfg.options     = {}

    cfg.files = [{
      expand: true
      src:    @getImagesFiles()
      filter: (file) => @fileCacheUpdateIfChanged(file)
    }]

    cfg