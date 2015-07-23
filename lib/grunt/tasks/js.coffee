module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_js', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_js_copy', t1, t2
    taskRunner.runGruntTask 'graspi_js_coffee_compile', t1, t2
    taskRunner.runGruntTask 'graspi_js_concat', t1, t2
    taskRunner.runGruntTask 'graspi_js_uglify', t1, t2

  grunt.registerTask 'graspi_js_copy', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/copy'

  grunt.registerTask 'graspi_js_coffee_compile', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/coffee_compile'

  grunt.registerTask 'graspi_js_concat', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/concat'

  grunt.registerTask 'graspi_js_uglify', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/uglify'

  grunt.registerTask 'graspi_js_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/clean'

  grunt.registerTask 'graspi_js_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_js_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/js/clean_full'