_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-fonts-clean'

  cached: false

  # ------------------------------------------------------------

  getFiles: ->
    _.map @getConfig().fonts.copy.formats, (format) =>
      File.join(@getDestPath(), "**/*.#{format}")

  buildConfig: ->
    { src: @getFiles() }
