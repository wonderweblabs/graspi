module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "graspi-js-clean-#{super()}"

  getTmpFilesUrl: ->
    "#{@getConfig().tmp.js}/#{@getAppConfig().js.destFile}/{,*/}*.js"

  buildConfig: ->
    cfg     = {}

    cfg.src = [
      @getTmpFilesUrl(),
      "#{@getTmpFilesUrl()}.map",
      @getDestFilePath(),
      "#{@getDestFilePath()}.map"
    ]

    cfg
