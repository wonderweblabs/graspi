_         = require 'lodash'
File      = require 'path'
JsonFile  = require '../../util/json_file'

module.exports = class TaskHelper extends require('./abstract')

  gruntTask: 'shell'

  gruntTaskTargetAppendix: 'graspi-webcomponents-bower-register'

  cacheKeyAppendix: 'webcomponents-bower-register'

  cached: false

  enabled: -> super() && @grunt.file.exists(@getModuleBowerFile())


  # ------------------------------------------------------------

  getModuleBowerFile: ->
    File.join(@getDestPath(), 'bower.json')

  getBowerFolder: ->
    return @getDestPath() unless _.isObject(@getConfig().webcomponents)
    return @getDestPath() unless _.isObject(@getConfig().webcomponents.bower)
    return @getDestPath() unless _.isString(@getConfig().webcomponents.bower.cwd)
    return @getDestPath() if _.isEmpty(@getConfig().webcomponents.bower.cwd)

    @getConfig().webcomponents.bower.cwd

  getBowerFile: ->
    File.join(@getConfig().webcomponents.bower.cwd, @getConfig().webcomponents.bower.jsonPath)

  run: ->
    @addToBowerJson()
    @removeDotFile()

  addToBowerJson: ->
    json  = new JsonFile(@grunt)
    bower = json.read(@getBowerFile())
    bower["dependencies"] or= {}

    unless _.isString(bower["dependencies"][@getModName()])
      relative = File.relative(File.dirname(@getBowerFile()), @getDestPath())

      bower["dependencies"][@getModName()] = "./#{relative}"

      json.write(@getBowerFile(), bower)

  removeDotFile: ->
    return unless @fileCacheUpdateIfChanged(@getModuleBowerFile())
    return unless @grunt.file.isFile(File.join(@getDestPath(), '.bower.json'))

    @grunt.file.delete(File.join(@getDestPath(), '.bower.json'))

