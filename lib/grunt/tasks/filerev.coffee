module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_filerev', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/filerev/filerev'

  grunt.registerTask 'graspi_filerev_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/filerev/clean'

  grunt.registerTask 'graspi_filerev_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_filerev_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/filerev/clean_full'