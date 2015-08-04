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
module.exports = (grunt, options = {}) ->

  # gruntRoot
  options.gruntRoot or= require('path').join(__dirname, '..')

  # configTmpFile
  options.configTmpFile or= 'tmp/graspi/config.yml'

  # projectConfigFolder
  # options.projectConfigFolder = null

  # tasksLoadPaths
  options.tasksLoadPaths or= []
  options.tasksLoadPaths.push require('path').join(__dirname, 'task_helpers')

  # require
  _           = require('./util/lodash_extensions')
  config      = require('./util/config')(grunt, options)
  taskRunner  = require('./util/task_runner')(grunt, config, options)

  require('./tasks/images')(grunt, config)
  require('./tasks/fonts')(grunt, config, options)
  require('./tasks/templates')(grunt, config, options)
  require('./tasks/webcomponents')(grunt, config, options)
  require('./tasks/css')(grunt, config, options)
  require('./tasks/js')(grunt, config, options)
  require('./tasks/replace')(grunt, config)
  require('./tasks/filerev')(grunt, config)
  require('./tasks/manifest')(grunt, config)
  require('./tasks/live')(grunt, config)

  grunt.registerTask 'graspi', (env_name, mod_name, task_name) ->
    if task_name == 'clean'
      taskRunner.runGraspiTask env_name, mod_name, task_name, true, 'clean', false
    else if task_name == 'clean_full'
      taskRunner.runGraspiTask env_name, mod_name, task_name, true, 'clean_full', false
    else
      taskRunner.runGraspiTask env_name, mod_name, task_name, true

  # ----------------------------------------------------------------
  # base tasks
  # ----------------------------------------------------------------

  grunt.registerTask 'graspi_build', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_build/build'
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_build/after_build'

  grunt.registerTask 'graspi_build_clean', (env_name, mod_name) ->
    taskRunner.runGraspiTaskHelper env_name, mod_name, 'graspi_clean/clean'

  grunt.registerTask 'graspi_build_clean_full', (env_name, mod_name) ->
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
  return config






