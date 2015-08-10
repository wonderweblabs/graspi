_         = require('lodash')
JsonFile  = require './class/json_file'

obj = null

module.exports = (grunt) ->
  obj = new JsonFile(grunt) unless _.isObject(obj)

  return obj
