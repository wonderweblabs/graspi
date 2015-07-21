module.exports = (grunt) ->

  taskRunner  = require('../util/task_runner')(grunt)
  eai         = require('../util/env_app_iterator')(grunt)

  grunt.registerTask 'graspi_filerev', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/filerev/filerev'

  grunt.registerTask 'graspi_filerev_clean', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/filerev/clean'

  grunt.registerTask 'graspi_filerev_clean_full', (t1, t2) ->
    taskRunner.runGruntTask @options().configFile, 'graspi_filerev_clean', t1, t2
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/filerev/clean_full'