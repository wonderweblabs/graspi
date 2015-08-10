module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_fonts', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_fonts_copy'

  grunt.registerTask 'graspi_fonts_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'fonts/copy'

  grunt.registerTask 'graspi_fonts_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'fonts/clean'

  grunt.registerTask 'graspi_fonts_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_fonts_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'fonts/clean_full'