module.exports = (grunt) ->

  taskRunner = require('./util/task_runner')(grunt)

  require('./tasks/bower')(grunt)
  require('./tasks/image_min')(grunt)
  require('./tasks/css')(grunt)
  require('./tasks/js')(grunt)
  require('./tasks/filerev')(grunt)
  require('./tasks/manifest')(grunt)

  grunt.registerTask 'graspi', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min', target1, target2
    taskRunner.runGruntTask c, 'graspi_css', target1, target2
    taskRunner.runGruntTask c, 'graspi_js', target1, target2
    taskRunner.runGruntTask c, 'graspi_filerev', target1, target2
    taskRunner.runGruntTask c, 'graspi_manifest', target1, target2
    # taskRunner.runGruntTask c, 'graspi_css_replace_urls', target1, target2

  grunt.registerTask 'graspi_clean', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_css_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_js_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_filerev_clean', target1, target2
    taskRunner.runGruntTask c, 'graspi_manifest_clean', target1, target2

  grunt.registerTask 'graspi_clean_full', (target1, target2) ->
    c = @options().configFile

    taskRunner.runGruntTask c, 'graspi_bower_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_image_min_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_css_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_js_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_filerev_clean_full', target1, target2
    taskRunner.runGruntTask c, 'graspi_manifest_clean_full', target1, target2


