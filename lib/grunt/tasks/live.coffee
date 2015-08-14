module.exports = (grunt) ->

  taskRunner = grunt.graspi.taskRunner

  grunt.registerTask 'graspi_watch', (env_name, mod_name) ->
    # taskRunner.runGraspiTask
    #   env_name: env_name
    #   mod_name: mod_name
    #   task_name: 'graspi_clean'
    #   resolveDeps: true
    #   depsTask: 'graspi_clean'
    # taskRunner.runGraspiTask
    #   env_name: env_name
    #   mod_name: mod_name
    #   task_name: 'build'
    #   resolveDeps: true
    #   depsTask: 'build'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'browsersync/browsersync'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'watch/watch'

  #
  # only for internal usage!!!
  #
  grunt.registerTask 'graspi_live_watch', (env_name, mod_name, task_name) ->
    taskRunner.runGraspiTask
      env_name: env_name
      mod_name: mod_name
      task_name: task_name
      resolveDeps: true
      depsTask: 'graspi_build'

    grunt.graspi.config.saveFileCacheTrackers()