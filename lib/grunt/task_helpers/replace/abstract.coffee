_     = require 'lodash'
File  = require 'path'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'replace'

  enabled: -> _.isObject(@getAppConfig().replace)

  # ------------------------------------------------------------
