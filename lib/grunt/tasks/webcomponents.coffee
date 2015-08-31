module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_webcomponents', (env_name, mod_name) ->
    # taskRunner.runGraspiTask
    #   env_name: env_name
    #   mod_name: mod_name
    #   task_name: 'graspi_webcomponents_concat'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_copy'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_haml'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_sass'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_coffee'
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_bower_register'
    # taskRunner.runGraspiTask
    #   env_name: env_name
    #   mod_name: mod_name
    #   task_name: 'graspi_webcomponents_bower'

  grunt.registerTask 'graspi_webcomponents_concat', (env_name, mod_name) ->
    grunt.log.error 'Attention, graspi_webcomponents_concat is deprecated.'
    # taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/concat'


  grunt.registerTask 'graspi_webcomponents_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/copy'

  grunt.registerTask 'graspi_webcomponents_haml', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/haml'

  grunt.registerTask 'graspi_webcomponents_sass', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/sass'

  grunt.registerTask 'graspi_webcomponents_coffee', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/coffee'

  grunt.registerTask 'graspi_webcomponents_bower', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/bower'

  grunt.registerTask 'graspi_webcomponents_bower_register', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/bower_register'

  grunt.registerTask 'graspi_webcomponents_bower_vulcanize', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/bower_vulcanize'

  grunt.registerTask 'graspi_webcomponents_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/clean'

  grunt.registerTask 'graspi_webcomponents_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_webcomponents_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/clean_full'