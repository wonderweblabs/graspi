module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_css', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_css_copy', t1, t2
    taskRunner.runGruntTask 'graspi_css_sass_compile', t1, t2
    taskRunner.runGruntTask 'graspi_css_concat', t1, t2
    taskRunner.runGruntTask 'graspi_css_minify', t1, t2

  grunt.registerTask 'graspi_css_copy', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/copy'

  grunt.registerTask 'graspi_css_sass_compile', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/sass_compile'

  grunt.registerTask 'graspi_css_concat', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/concat'

  grunt.registerTask 'graspi_css_minify', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/minify'

  grunt.registerTask 'graspi_css_replace_urls', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/replace_urls'

  grunt.registerTask 'graspi_css_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/clean'

  grunt.registerTask 'graspi_css_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_css_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/css/clean_full'