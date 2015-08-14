_     = require 'lodash'
File  = require 'path'
YF    = require './yaml_file'

module.exports = class UserConfig

  constructor: (@grunt, @configRootPath) ->
    @_config = {}

    @_loadConfig()

  getYamlFileHandler: ->
    @_yamlFileHandler or= new YF(@grunt)

  getConfig: ->
    @_config

  getFile: ->
    File.join(@configRootPath, '.graspi.yml')

  getForceBuildModules: ->
    @getConfig().forceBuild || []


  # ----------------------------------------------------------
  # private

  # @nodoc
  _loadConfig: ->
    @_config = @getYamlFileHandler().read(@getFile()) || {}