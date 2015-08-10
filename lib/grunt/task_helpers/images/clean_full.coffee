_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-images-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      File.join(@getDestPath(), '**/*.jpeg')
      File.join(@getDestPath(), '**/*.jpg')
      File.join(@getDestPath(), '**/*.gif')
      File.join(@getDestPath(), '**/*.png')
      File.join(@getDestPath(), '**/*.svg')
    ]

  buildConfig: ->
    { src: @getFiles() }
