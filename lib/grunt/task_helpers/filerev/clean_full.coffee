_     = require 'lodash'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'clean'

  gruntTaskTargetAppendix: 'graspi-filerev-clean'

  cached: false

  # ------------------------------------------------------------

  buildConfig: ->
    { src: [@getMappingFile()] }
