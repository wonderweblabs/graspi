_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'coffee'

  gruntTaskTargetAppendix: 'graspi-js-coffee_compile'

  cacheKeyAppendix: 'js-coffee_compile'

  cached: -> @getConfig().js.coffee.cached == true

  enabled: ->
    super() &&
    _.isArray(@getAppConfig().js.files) &&
    _.size(@getCoffeeFiles()) > 0

  isCacheValid: ->
    _.inject @getCoffeeFiles(), true, (memo, file) =>
      return false if memo == false

      file = File.join(@getBasePath(), file)
      return !@fileCacheHasChanged(file) if @grunt.file.isFile(file)

      _.inject @grunt.file.expand(file), true, (subMemo, subFile) =>
        if subMemo == false then false else !@fileCacheHasChanged(subFile)

  # ------------------------------------------------------------

  getCoffeeFiles: ->
    @_coffeeFiles or= _.inject (@getAppConfig().js.files || []), [], (memo, file) =>
      memo.push file if /\.coffee$/.test(file)
      memo

  buildConfig: ->
    coffeeConfig = _.inject @getConfig().js.coffee.options, {}, (memo, value, key) =>
      return memo if value == 'undefined' || value == undefined
      return memo if value == 'null' || value == null

      memo[key] = value
      memo

    coffeeFiles = _.inject @getCoffeeFiles(), [], (memo, filesEntry) =>
      filesEntry = File.join(@getBasePath(), filesEntry)
      filesEntry = @grunt.file.expand(filesEntry) if !@grunt.file.isFile(filesEntry)
      filesEntry = [filesEntry] unless _.isArray(filesEntry)

      memo.concat(filesEntry)

    tmpFile = File.join(@getTmpPath(), @getAppConfig().js.destFile)

    cfg         = {}
    cfg.options = coffeeConfig
    cfg.files   = {}
    cfg.files[tmpFile] = coffeeFiles

    _.each coffeeFiles, (file) => @fileCacheUpdate(file)

    cfg
