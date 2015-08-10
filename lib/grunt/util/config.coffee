GraspiConfigBuilder = require './class/config_builder'

config = null

# ----------------------------------------------------------------
# export
# ----------------------------------------------------------------
module.exports = (grunt) ->
  if config == null
    builder = new GraspiConfigBuilder(grunt)
    config = builder.configure()

  return config





