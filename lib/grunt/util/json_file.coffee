_         = require './lodash_extensions'
JsonFile  = require './class/json_file'

obj = null

module.exports = (grunt) ->
  obj = new JsonFile(_, grunt) unless _.isObject(obj)

  return obj
