_ = require 'lodash'

module.exports = class JsonFileHandler

  constructor: (@grunt) ->

  read: (file) ->
    return {} unless @grunt.file.exists(file)

    try
      json = @grunt.file.readJSON(file, { encoding: 'utf-8' })
      json or= {}
      json = {} unless _.isObject(json)

      return json
    catch e
      return {}

  write: (file, json, prettyPrint = true) ->
    return unless _.isObject(json)

    spaces  = if prettyPrint == true then 4 else 0
    json    = JSON.stringify(json, null, spaces)

    @grunt.file.write(file, json, { encoding: 'utf-8' })