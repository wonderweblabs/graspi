_ = require('lodash')

module.exports = class YamlFileHandler

  constructor: (@grunt) ->

  read: (file) ->
    return {} unless @grunt.file.exists(file)

    yaml = @grunt.file.readYAML(file, { encoding: 'utf-8' })
    yaml or= {}
    yaml = {} unless _.isObject(yaml)

    yaml
