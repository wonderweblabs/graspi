module.exports = (grunt) ->

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt, {
    graspi: 'lib/grunt/graspi.coffee'
    graspi_clean: 'lib/grunt/graspi.coffee'
    graspi_clean_full: 'lib/grunt/graspi.coffee'
  })


  # ----------------------------------------------------------------
  # Grunt config
  # ----------------------------------------------------------------

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    graspi:
      options:
        configFile: 'graspi.yml'
    graspi_clean:
      options:
        configFile: 'graspi.yml'
    graspi_clean_full:
      options:
        configFile: 'graspi.yml'

  grunt.registerTask('default', [
    'graspi',
    'graspi:development',
    'graspi:base',
    'graspi:development:base',
  ])

  null