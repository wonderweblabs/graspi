_         = require('lodash')
YamlFile  = require './class/yaml_file'

obj = null

module.exports = (grunt) ->
  obj = new YamlFile(grunt) unless _.isObject(obj)

  return obj
