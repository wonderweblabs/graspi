module.exports = class TaskHelper extends require('./abstract')

  run: ->
    @getCache().setBuildCache(@getEmc(), @options.wrapping_task_name)
    @grunt.graspi.config.saveFileCacheTrackers()
    @grunt.graspi.config.saveBuildCacheTrackers()
