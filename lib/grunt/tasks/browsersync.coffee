module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_browsersync', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/browsersync/browsersync'

    taskRunner.runGruntTask 'browserSync', null, null