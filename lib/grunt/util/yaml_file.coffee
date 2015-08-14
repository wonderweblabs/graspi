_ = require('lodash')

module.exports = class YamlFileHandler

  constructor: (@grunt) ->

  read: (file) ->
    return {} unless @grunt.file.exists(file)

    try
      yaml = @grunt.file.readYAML(file, { encoding: 'utf-8' })
      yaml or= {}
      yaml = {} unless _.isObject(yaml)

      return yaml
    catch e
      return {}
