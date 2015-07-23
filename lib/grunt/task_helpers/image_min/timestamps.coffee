module.exports = class TaskHelper extends require('./abstract')

  run: ->
    @_.each @g.file.expand("#{@getDestFullPath()}/{,*/}*.{jpeg,jpg,gif,png,svg}"), (path) =>
      @fileCacheUpdate(path)
