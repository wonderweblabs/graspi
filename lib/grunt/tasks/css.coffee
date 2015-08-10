module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_css', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_css_copy'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_css_sass_compile'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_css_concat'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_css_minify'

  grunt.registerTask 'graspi_css_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/copy'

  grunt.registerTask 'graspi_css_sass_compile', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/sass_compile'

  grunt.registerTask 'graspi_css_concat', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/concat'

  grunt.registerTask 'graspi_css_minify', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/minify'

  grunt.registerTask 'graspi_css_replace_urls', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/replace_urls'

  grunt.registerTask 'graspi_css_polymer_mixin_replace', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/polymer_mixin_replace'

  grunt.registerTask 'graspi_css_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/clean'

  grunt.registerTask 'graspi_css_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_css_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'css/clean_full'