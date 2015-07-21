module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "graspi-css-clean-#{super()}"

  getTmpFilesUrl: ->
    "#{@getConfig().tmp.css}/#{@getAppConfig().css.destFile}/{,*/}*.css"

  buildConfig: ->
    cfg     = {}

    cfg.src = [
      @getTmpFilesUrl(),
      "#{@getTmpFilesUrl()}.map",
      @getDestFilePath(),
      "#{@getDestFilePath()}.map"
    ]

    cfg
