module.exports = (grunt, configPath) ->

  taskRunner  = require('../util/task_runner')(grunt, configPath)

  grunt.registerTask 'graspi_image_min', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_image_min_copy', t1, t2
    taskRunner.runGruntTask 'graspi_image_min_imagemin', t1, t2
    taskRunner.runGruntTask 'graspi_image_min_svgmin', t1, t2
    taskRunner.runGruntTask 'graspi_image_min_update_timestamps', t1, t2

  grunt.registerTask 'graspi_image_min_copy', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/copy'

  grunt.registerTask 'graspi_image_min_imagemin', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/imagemin'

  grunt.registerTask 'graspi_image_min_svgmin', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/svgmin'

  grunt.registerTask 'graspi_image_min_update_timestamps', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/timestamps'

  grunt.registerTask 'graspi_image_min_clean', (t1, t2) ->
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/clean'

  grunt.registerTask 'graspi_image_min_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_image_min_clean', t1, t2
    taskRunner.runGraspiTask t1, t2, 'task_helpers/image_min/clean_full'