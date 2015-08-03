module.exports = (grunt, config, options) ->

  taskRunner  = require('../util/task_runner')(grunt, config, options)

  grunt.registerTask 'graspi_manifest', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/manifest'

  grunt.registerTask 'graspi_manifest_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/clean'

  grunt.registerTask 'graspi_manifest_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask env_name, mod_name, 'graspi_manifest_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/clean_full'