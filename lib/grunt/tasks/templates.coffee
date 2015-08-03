module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_templates', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_templates_copy'
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_templates_haml'
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_templates_concat'

  grunt.registerTask 'graspi_templates_copy', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'templates/copy'

  grunt.registerTask 'graspi_templates_haml', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'templates/haml'

  grunt.registerTask 'graspi_templates_concat', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'templates/concat'

  grunt.registerTask 'graspi_templates_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'templates/clean'

  grunt.registerTask 'graspi_templates_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_templates_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'templates/clean_full'