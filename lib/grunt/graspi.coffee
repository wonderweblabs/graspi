module.exports = (grunt) ->

  taskRunner = require('./util/task_runner')(grunt)

  require('./tasks/bower')(grunt)
  require('./tasks/image_min')(grunt)

  grunt.registerTask 'graspi', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min', target1, target2

  grunt.registerTask 'graspi_clean', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min_clean', target1, target2

  grunt.registerTask 'graspi_clean_full', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min_clean_full', target1, target2


