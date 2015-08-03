_                   = require './lodash_extensions'
File                = require 'path'
GraspiConfigBuilder = require './class/config_builder'

config = null

# ----------------------------------------------------------------
# export
# ----------------------------------------------------------------
module.exports = (grunt, options) ->
  if config == null
    builder = new GraspiConfigBuilder(_, File, grunt, options)
    config = builder.configure()

  return config





