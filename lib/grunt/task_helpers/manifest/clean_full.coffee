module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "graspi-manifest-clean-#{super()}"

  buildConfig: ->
    {}
    # cfg     = {}

    # cfg.src = []

    # cfg
