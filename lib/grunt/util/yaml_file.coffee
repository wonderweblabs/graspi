_         = require './lodash_extensions'
YamlFile  = require './class/yaml_file'

obj = null

module.exports = (grunt) ->
  obj = new YamlFile(_, grunt) unless _.isObject(obj)

  return obj
