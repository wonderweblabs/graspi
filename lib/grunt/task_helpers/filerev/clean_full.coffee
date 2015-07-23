module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "graspi-filerev-clean-#{super()}"

  buildConfig: ->
    cfg     = {}

    cfg.src = [@getMappingFilePath()]

    cfg
