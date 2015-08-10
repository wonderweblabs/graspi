module.exports = (grunt) ->

  File    = require('path')
  basedir = File.resolve()

  # Time how long tasks take. Can help when optimizing build times
  # require('time-grunt')(grunt)

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt)

  # graspi configuration
  grunt.option('root', basedir)
  grunt.option('configCache', File.join(basedir, 'spec/dummy/tmp/graspi/config.yml'))
  grunt.option('configLoadPaths', [File.join(basedir, 'spec/dummy/config/graspi')])
  require('./lib/grunt/graspi')(grunt)


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