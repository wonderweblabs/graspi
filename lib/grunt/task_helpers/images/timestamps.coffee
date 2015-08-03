_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  run: ->
    formats = (@getConfig().images.copy.formats || [])

    _.each formats, (format) =>
      _.each @g.file.expand(File.join(@getDestPath(), "**/*.#{format}")), (path) =>
        @fileCacheUpdate(path)
