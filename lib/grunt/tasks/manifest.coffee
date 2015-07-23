module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_manifest', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/manifest/manifest'

  grunt.registerTask 'graspi_manifest_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/manifest/clean'

  grunt.registerTask 'graspi_manifest_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_manifest_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/manifest/clean_full'