_     = require 'lodash'
File  = require 'path'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'shell'

  gruntTaskTargetAppendix: 'graspi-webcomponents-vulcanize'

  cacheKeyAppendix: 'webcomponents-vulcanize'

  cached: false

  enabled: -> super() && _.size(@getFiles()) > 0

  isCacheValid: ->
    _.inject @getFiles(), true, (memo, file) =>
      return false if memo == false

      @fileCacheHasChanged(file)

  # ------------------------------------------------------------

  getFiles: ->
    @_files or= @grunt.file.expand({
      filter: 'isFile'
      cwd: @getConfig().destPathWC
    }, '**/*')

  buildConfig: ->
    cfg                     = {}
    cfg.options             = {}
    cfg.options.stdout      = true
    cfg.options.stderr      = true
    cfg.options.stdin       = true
    cfg.options.failOnError = true
    cfg.options.execOptions = {}

    command = ['vulcanize']
    command.push "--abspath '#{File.join(@getConfig().destPathWC)}'"
    command.push "--inline-scripts"
    command.push "--inline-css"

    f = @getAppConfig().webcomponents.files[0]
    f = File.join(@getAppConfig().webcomponents.baseRelPath, f)
    command.push "'#{f}'"
    command.push '>'

    destFile = @getAppConfig().webcomponents.destRelPath
    destFile = File.join(destFile, @getAppConfig().webcomponents.destFile)
    command.push destFile

    @grunt.file.mkdir(File.dirname(destFile))

    cfg.command = command.join(' ')
    cfg