module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "graspi-image-min-clean-#{super()}"

  buildConfig: ->
    cfg     = {}

    cfg.src = ["#{@getDestFullPath()}/{,*/}*.{jpeg,jpg,gif,png,svg}"]

    cfg