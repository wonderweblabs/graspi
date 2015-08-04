module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_webcomponents', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_webcomponents_concat'

  grunt.registerTask 'graspi_webcomponents_concat', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/concat'

  grunt.registerTask 'graspi_webcomponents_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/clean'

  grunt.registerTask 'graspi_webcomponents_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_webcomponents_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'webcomponents/clean_full'