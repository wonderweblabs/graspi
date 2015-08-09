module.exports = (grunt) ->

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # graspi configuration
  File   = require('path')
  dir    = File.resolve()
  graspi = require('./lib/grunt/graspi')(grunt,
    gruntRoot:            dir
    configTmpFile:        File.join(dir, 'spec/dummy/tmp/graspi/config.yml')
    configLoadPaths:      [
      File.join(dir, 'spec/dummy/config/graspi')
    ]
    tasksLoadPaths:       []
  )

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt)

  # ----------------------------------------------------------------
  # tasks
  # ----------------------------------------------------------------

  grunt.registerTask('default', ['graspi'])

  grunt.registerTask('watchAndSync', [
    'graspi_clean',
    'graspi',
    'graspi_browsersync',
    'graspi_watch'
  ])

  # ----------------------------------------------------------------
  # Grunt config
  # ----------------------------------------------------------------
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  null