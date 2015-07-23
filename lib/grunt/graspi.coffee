#
# graspi       -> base module
# task runner  -> task execution with some preparing mechanisms and
#                 environment switches.
# eac          -> "environment app config" the config for a specific environment
#                 for a specific app. Values:
#                   * eac.env_name  - Name of the environment
#                   * eac.env       - Environment config hash
#                   * eac.app_name  - Name of the app
#                   * eac.app       - App config hash
#                   * eac.appConfig - Merged config (base + env + app)
# eai          -> "environment app iterator" utility to iterate over all combinations
#                 of environments and apps. You can use "eachWithTargets" or "each" and
#                 pass a callback function. The funcation will get an eac object
#                 as parameter.
#
module.exports = (grunt, configPath) ->

  require('./tasks/bower')(grunt, configPath)
  require('./tasks/image_min')(grunt, configPath)
  require('./tasks/css')(grunt, configPath)
  require('./tasks/js')(grunt, configPath)
  require('./tasks/filerev')(grunt, configPath)
  require('./tasks/manifest')(grunt, configPath)
  require('./tasks/browsersync')(grunt, configPath)
  require('./tasks/watch')(grunt, configPath)

  _           = require('./util/lodash_extensions')
  taskRunner  = require('./util/task_runner')(grunt, configPath)

  cfg =
    taskRunner: taskRunner
    eai: taskRunner.getEai()
    config: taskRunner.getC()


  # ----------------------------------------------------------------
  # base tasks
  # ----------------------------------------------------------------

  grunt.registerTask 'graspi', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_bower', t1, t2
    taskRunner.runGruntTask 'graspi_image_min', t1, t2
    taskRunner.runGruntTask 'graspi_css', t1, t2
    taskRunner.runGruntTask 'graspi_js', t1, t2
    taskRunner.runGruntTask 'graspi_filerev', t1, t2
    taskRunner.runGruntTask 'graspi_manifest', t1, t2
    taskRunner.runGruntTask 'graspi_css_replace_urls', t1, t2

  grunt.registerTask 'graspi_clean', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_bower_clean', t1, t2
    taskRunner.runGruntTask 'graspi_image_min_clean', t1, t2
    taskRunner.runGruntTask 'graspi_css_clean', t1, t2
    taskRunner.runGruntTask 'graspi_js_clean', t1, t2
    taskRunner.runGruntTask 'graspi_filerev_clean', t1, t2
    taskRunner.runGruntTask 'graspi_manifest_clean', t1, t2

  grunt.registerTask 'graspi_clean_full', (t1, t2) ->
    taskRunner.runGruntTask 'graspi_bower_clean_full', t1, t2
    taskRunner.runGruntTask 'graspi_image_min_clean_full', t1, t2
    taskRunner.runGruntTask 'graspi_css_clean_full', t1, t2
    taskRunner.runGruntTask 'graspi_js_clean_full', t1, t2
    taskRunner.runGruntTask 'graspi_filerev_clean_full', t1, t2
    taskRunner.runGruntTask 'graspi_manifest_clean_full', t1, t2


  # ----------------------------------------------------------------
  # build dynamic tasks
  # ----------------------------------------------------------------

  customTasks = []
  taskRunner.getEai().each (eac) ->
    customTasks = customTasks.concat(Object.keys(eac.appConfig.tasks || {}))
  customTasks = _.uniq(customTasks)

  _.each customTasks, (task) ->
    grunt.registerTask task, (t1, t2) ->
      taskRunner.runDynamicTask task, t1, t2

  # ----------------------------------------------------------------
  return cfg






