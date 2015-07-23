module.exports = class TaskHelper extends require('./abstract')

  isEnabled: ->
    true

  run: ->
    return unless @isEnabled()

    @fileCacheClean()