module.exports = class TaskHelper extends require('./abstract')

  run: ->
    return unless @isEnabled()

    @fileCacheClean()