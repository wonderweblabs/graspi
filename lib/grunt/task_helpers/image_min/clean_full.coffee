module.exports = class TaskHelper extends require('./abstract')

  getGruntTask: ->
    'clean'

  getGruntTaskTarget: ->
    "wwl-image-min-clean-#{super()}"

  buildConfig: ->
    {}
    # cfg     = {}
    # cfg.src = []

    # if @_.isObject(@eac.appConfig.config.js)
    #   cfg.src.push "#{@eac.appConfig.tmp.js}/#{@eac.appConfig.config.js.destFile}/1_bower.js"

    # if @_.isObject(@eac.appConfig.config.css)
    #   cfg.src.push "#{@eac.appConfig.tmp.css}/#{@eac.appConfig.config.css.destFile}/1_bower.css"

    # console.log cfg
    # cfg