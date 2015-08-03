_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-manifest-clean'

  cached: false

  # ------------------------------------------------------------

  buildConfig: ->
    { src: [@getManifestFile()] }
