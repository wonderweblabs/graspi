_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-images-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      File.join(@getAppConfig().destPath, '**/*.jpeg')
      File.join(@getAppConfig().destPath, '**/*.jpg')
      File.join(@getAppConfig().destPath, '**/*.gif')
      File.join(@getAppConfig().destPath, '**/*.png')
      File.join(@getAppConfig().destPath, '**/*.svg')
    ]

  buildConfig: ->
    { src: @getFiles() }
