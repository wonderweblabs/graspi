_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-templates-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      @getDestFile(),
      File.join(@getTmpPath(), 'templates', '**/*')
    ]

  buildConfig: ->
    { src: @getFiles() }