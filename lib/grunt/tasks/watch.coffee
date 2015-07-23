module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_watch', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/watch/watch'

    taskRunner.runGruntTask 'watch', null, null
