module.exports = (grunt) ->

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # graspi configuration
  File    = require('path')
  dir     = File.resolve()
  config  = File.join(dir, 'graspi.yml')
  cfg = require('./lib/grunt/graspi')(grunt, config)

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