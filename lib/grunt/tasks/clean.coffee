module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean'

  grunt.registerTask 'graspi_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean_full'