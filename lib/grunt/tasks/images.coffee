module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_images', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_images_copy'
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_images_imagemin'
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_images_svgmin'
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_images_update_timestamps'

  grunt.registerTask 'graspi_images_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/copy'

  grunt.registerTask 'graspi_images_imagemin', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/imagemin'

  grunt.registerTask 'graspi_images_svgmin', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/svgmin'

  grunt.registerTask 'graspi_images_update_timestamps', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/timestamps'

  grunt.registerTask 'graspi_images_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/clean'

  grunt.registerTask 'graspi_images_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_images_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'images/clean_full'