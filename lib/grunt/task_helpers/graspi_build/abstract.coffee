module.exports = class AbstractTaskHelper extends require('../abstract')

  getCache: ->
    @grunt.graspi.config.getBuildCacheTracker(@getEmc())
