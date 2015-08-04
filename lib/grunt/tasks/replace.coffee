module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_replace', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'replace/replace'

  grunt.registerTask 'graspi_replace_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'replace/clean'

  grunt.registerTask 'graspi_replace_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_replace_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'replace/clean_full'