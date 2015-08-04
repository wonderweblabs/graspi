_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-webcomponents-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      @getDestFile(),
      File.join(@getTmpPath(), '**/*')
    ]

  buildConfig: ->
    { src: @getFiles() }