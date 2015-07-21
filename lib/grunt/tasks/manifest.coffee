module.exports = (grunt) ->

  taskRunner  = require('../util/task_runner')(grunt)
  eai         = require('../util/env_app_iterator')(grunt)

  grunt.registerTask 'graspi_manifest', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/manifest/manifest'

  grunt.registerTask 'graspi_manifest_clean', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/manifest/clean'

  grunt.registerTask 'graspi_manifest_clean_full', (t1, t2) ->
    taskRunner.runGruntTask @options().configFile, 'graspi_manifest_clean', t1, t2
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/manifest/clean_full'