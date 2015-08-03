_           = require './lodash_extensions'
File        = require 'path'
TaskRunner  = require './class/task_runner'

tr = null

module.exports = (grunt, config, basePath) ->
  tr = new TaskRunner(_, File, grunt, config, basePath) if tr == null

  return tr