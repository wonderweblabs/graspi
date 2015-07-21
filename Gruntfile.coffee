module.exports = (grunt) ->

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt, {
    graspi:             'lib/grunt/graspi.coffee'
    graspi_clean:       'lib/grunt/graspi.coffee'
    graspi_clean_full:  'lib/grunt/graspi.coffee'
    graspi_bower:       'lib/grunt/tasks/bower.coffee'
    graspi_image_min:   'lib/grunt/tasks/image_min.coffee'
    graspi_css:         'lib/grunt/tasks/css.coffee'
    graspi_js:          'lib/grunt/tasks/js.coffee'
    graspi_filerev:     'lib/grunt/tasks/filerev.coffee'
    graspi_filerev_clean:      'lib/grunt/tasks/filerev.coffee'
    graspi_filerev_clean_full: 'lib/grunt/tasks/filerev.coffee'
    graspi_manifest:    'lib/grunt/tasks/manifest.coffee'
    graspi_manifest_clean:      'lib/grunt/tasks/manifest.coffee'
    graspi_manifest_clean_full: 'lib/grunt/tasks/manifest.coffee'
  })

  # ----------------------------------------------------------------
  # Grunt config
  # ----------------------------------------------------------------

  graspi_tasks = [
    'graspi',
    'graspi_clean',
    'graspi_clean_full',
    'graspi_bower',
    'graspi_image_min',
    'graspi_css',
    'graspi_js',
    'graspi_filerev',
    'graspi_filerev_clean',
    'graspi_filerev_clean_full',
    'graspi_manifest',
    'graspi_manifest_clean',
    'graspi_manifest_clean_full'
  ]

  cfg =
    pkg: grunt.file.readJSON 'package.json'

  for task in graspi_tasks
    cfg[task] = { options: { configFile: 'graspi.yml' } }

  grunt.initConfig cfg

  grunt.registerTask('default', [
    'graspi',
    'graspi:development',
    'graspi:base',
    'graspi:development:base',
  ])

  null