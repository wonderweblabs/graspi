module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_watch', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'browsersync/browsersync'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'watch/watch'
