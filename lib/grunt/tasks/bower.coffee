module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_bower', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_bower_concat_check', t1, t2
    taskRunner.runGruntTask 'graspi_bower_concat', t1, t2

  grunt.registerTask 'graspi_bower_concat_check', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/bower/concat_check'

  grunt.registerTask 'graspi_bower_concat', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/bower/concat'

  grunt.registerTask 'graspi_bower_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/bower/clean'

  grunt.registerTask 'graspi_bower_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_bower_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/bower/clean_full'

