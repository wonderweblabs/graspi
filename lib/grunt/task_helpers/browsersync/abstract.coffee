_ = require 'lodash'

module.exports = class AbstractTaskHelper extends require('../abstract')

  cacheKeyAppendix: 'browsersync'

  enabled: -> _.isObject(@getConfig().live.browserSync)

  # ------------------------------------------------------------