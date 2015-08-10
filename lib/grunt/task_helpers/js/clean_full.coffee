_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-js-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      File.join(@getDestPath(), '**/*.js'),
      File.join(@getDestPath(), '**/*.js.map'),
      File.join(@getTmpPath(), '**/*.coffee'),
      File.join(@getTmpPath(), '**/*.coffee.map'),
      File.join(@getTmpPath(), '**/*.js'),
      File.join(@getTmpPath(), '**/*.js.map')
    ]

  buildConfig: ->
    { src: @getFiles() }