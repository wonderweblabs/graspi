#
# graspi       -> base module
# task runner  -> task execution with some preparing mechanisms and
#                 environment switches.
# emc          -> "environment module config" the config for a specific environment
#                 for a specific app. Values:
#                   * emc.config    - The main config instance
#                   * emc.env_name  - Name of the environment
#                   * emc.mod_name  - Name of the module
#                   * emc.emc       - Merged config (base + env + module)
#
module.exports = (grunt) ->

  _     = require('./util/lodash_extensions')
  File  = require('path')

  # environment (default)
  unless _.isString(grunt.option('env_name'))
    grunt.option('env_name', 'development')

  # module (default)
  unless _.isString(grunt.option('mod_name'))
    grunt.option('mod_name', null)

  # task (default)
  unless _.isString(grunt.option('task_name'))
    grunt.option('task_name', 'build')

  # grunt root
  unless _.isString(grunt.option('root'))
    grunt.option('root', File.join(__dirname, '../..'))

  # config cache
  unless grunt.option('configCache')
    grunt.option('configCache', 'tmp/graspi/config.yml')

  # cached mode config/on/off
  unless _.isBoolean(grunt.option('cached'))
    grunt.option('cached', null)

  # cached dependencies mode config/on/off
  unless _.isBoolean(grunt.option('cachedDeps'))
    grunt.option('cachedDeps', null)

  # resolve dependency list
  unless _.isBoolean(grunt.option('resolveDeps'))
    grunt.option('resolveDeps', true)

  # include dependencies mode config/on/off
  unless _.isBoolean(grunt.option('includeDeps'))
    grunt.option('includeDeps', null)

  # task to execute for dependencies
  unless _.isString(grunt.option('depsTask'))
    grunt.option('depsTask', null)

  # config load paths
  paths = grunt.option('configLoadPaths') || []
  paths = [File.join(__dirname, '../..', 'config')].concat(paths)
  grunt.option('configLoadPaths', paths)

  # tasks load paths
  paths = grunt.option('tasksLoadPaths') || []
  paths = [File.join(__dirname, 'tasks')].concat(paths)
  grunt.option('tasksLoadPaths', paths)

  # task helper load paths
  paths = grunt.option('taskHelperLoadPaths') || []
  paths = [File.join(__dirname, 'task_helpers')].concat(paths)
  grunt.option('taskHelperLoadPaths', paths)

  # require
  grunt.graspi or= {}
  grunt.graspi.config     = require('./util/config')(grunt)
  grunt.graspi.taskRunner = require('./util/task_runner')(grunt)
  taskRunner              = grunt.graspi.taskRunner

  # task files
  _.each grunt.option('tasksLoadPaths'), (path) =>
    _.each grunt.file.expand(File.join(path, '**/*')), (file) =>
      return unless grunt.file.isFile(file)

      require(file)(grunt, {})

  # basic graspi task
  grunt.registerTask 'graspi', ->
    if !_.isString(grunt.option('mod_name'))
      grunt.fail.fatal('No module set. Please run graspi with --module=[mod_name] flag.')
    else if grunt.option('verbose') == true
      grunt.log.ok 'Graspi run options:'
      console.log grunt.option.flags()
      grunt.log.ok '-------------------'

    grunt.graspi.taskRunner.runGraspiTask
      env_name:       grunt.option('env_name')
      mod_name:       grunt.option('mod_name')
      task_name:      grunt.option('task_name')
      main_task_name: grunt.option('task_name')
      resolveDeps:    grunt.option('resolveDeps')
      depsCaching:    grunt.option('cachedDeps')
      depsTask:       grunt.option('depsTask') || grunt.option('task_name')

    grunt.graspi.config.saveFileCacheTrackers()


  # ----------------------------------------------------------------
  # base tasks
  # ----------------------------------------------------------------

  grunt.registerTask 'graspi_build', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_build/build'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_build/after_build'

  grunt.registerTask 'graspi_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean'

  grunt.registerTask 'graspi_clean_full', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean_full'

  # ----------------------------------------------------------------
  # build dynamic tasks
  # ----------------------------------------------------------------

  customTasks = []
  config.eachEmc null, null, (emc) ->
    customTasks = customTasks.concat(Object.keys(emc.emc.tasks || {}))
  customTasks = _.uniq(customTasks)
  customTasks = _.filter customTasks, (task_name) =>
    !_.includes(['build', 'graspi_build'], task_name)

  _.each customTasks, (task_name) ->
    grunt.registerTask task_name, (env_name, mod_name) ->
      taskRunner.runDynamicGraspiTask env_name, mod_name, task_name, true

  # ----------------------------------------------------------------
  # return config
  return {}






