module.exports = (grunt) ->

  taskRunner  = require('../util/task_runner')(grunt)
  eai         = require('../util/env_app_iterator')(grunt)

  grunt.registerTask 'graspi_css', (t1, t2) ->
    taskRunner.runGruntTask @options().configFile, 'graspi_css_copy', t1, t2
    taskRunner.runGruntTask @options().configFile, 'graspi_css_sass_compile', t1, t2
    taskRunner.runGruntTask @options().configFile, 'graspi_css_concat', t1, t2
    taskRunner.runGruntTask @options().configFile, 'graspi_css_minify', t1, t2

  grunt.registerTask 'graspi_css_copy', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/copy'

  grunt.registerTask 'graspi_css_sass_compile', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/sass_compile'

  grunt.registerTask 'graspi_css_concat', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/concat'

  grunt.registerTask 'graspi_css_minify', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/minify'

  grunt.registerTask 'graspi_css_replace_urls', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/replace_urls'

  grunt.registerTask 'graspi_css_clean', (t1, t2) ->
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/clean'

  grunt.registerTask 'graspi_css_clean_full', (t1, t2) ->
    taskRunner.runGruntTask @options().configFile, 'graspi_css_clean', t1, t2
    taskRunner.runGraspiTask @options().configFile, t1, t2, 'task_helpers/css/clean_full'