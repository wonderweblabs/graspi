TaskRunner  = require './class/task_runner'

tr = null

module.exports = (grunt) ->
  tr = new TaskRunner(grunt) if tr == null

  return tr