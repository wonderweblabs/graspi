_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-css-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    [
      File.join(@getAppConfig().destPath, '**/*.css'),
      File.join(@getAppConfig().destPath, '**/*.css.map'),
      File.join(@getTmpPath(), '**/*.sass'),
      File.join(@getTmpPath(), '**/*.sass.map'),
      File.join(@getTmpPath(), '**/*.scss'),
      File.join(@getTmpPath(), '**/*.scss.map'),
      File.join(@getTmpPath(), '**/*.less'),
      File.join(@getTmpPath(), '**/*.less.map'),
      File.join(@getTmpPath(), '**/*.css'),
      File.join(@getTmpPath(), '**/*.css.map')
    ]

  buildConfig: ->
    { src: @getFiles() }
