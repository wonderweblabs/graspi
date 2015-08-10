module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_filerev', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'filerev/filerev'

  grunt.registerTask 'graspi_filerev_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'filerev/clean'

  grunt.registerTask 'graspi_filerev_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: 'graspi_filerev_clean'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'filerev/clean_full'