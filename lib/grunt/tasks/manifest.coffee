module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_manifest', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/manifest'

  grunt.registerTask 'graspi_manifest_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/clean'

  grunt.registerTask 'graspi_manifest_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_manifest_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'manifest/clean_full'