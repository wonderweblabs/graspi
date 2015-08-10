module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_js', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_js_copy'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_js_coffee_compile'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_js_concat'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_js_uglify'

  grunt.registerTask 'graspi_js_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/copy'

  grunt.registerTask 'graspi_js_coffee_compile', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/coffee_compile'

  grunt.registerTask 'graspi_js_concat', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/concat'

  grunt.registerTask 'graspi_js_uglify', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/uglify'

  grunt.registerTask 'graspi_js_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/clean'

  grunt.registerTask 'graspi_js_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_js_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'js/clean_full'