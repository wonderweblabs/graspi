_     = require('../util/lodash_extensions')
fs    = require('fs')
path  = require('path')

tc          = {}
tc.trackers = {}

module.exports = (grunt, eac) ->
  tc.trackers[eac.env_name] or= {}
  tc.trackers[eac.env_name][eac.app_name] or= new ChangeTracker(grunt, eac)

  return tc.trackers[eac.env_name][eac.app_name]

class ChangeTracker

  constructor: (grunt, eac) ->
    @g    = grunt
    @eac  = eac

  clean: (scope = null) ->
    @getTimestampsJson(scope, true)
    @writeTimestampsFile()

  hasChanged: (path, scope = null) ->
    mtime       = @getCurrentTimestamp(path)
    cachedMTime = @getTimestamp(path, scope)

    cachedMTime.getTime() != mtime.getTime()

  update: (path, scope = null) ->
    mtime = @getCurrentTimestamp(path)

    @getTimestampsJson(scope)[path] = mtime
    @writeTimestampsFile()

    mtime

  getTimestamp: (path, scope = null) ->
    mtime = @getTimestampsJson(scope)[path]
    mtime = new Date(mtime) unless _.isEmpty(mtime)
    mtime or= new Date(0)

    mtime

  getCurrentTimestamp: (path) ->
    return new Date(0) unless @g.file.exists(path)

    stats = fs.statSync(path)

    return stats.mtime

  getTimestampsJson: (scope = null, clearScope = false) ->
    scope or= 'default'

    @_timestampsJson or= @readTimestampsFile()
    @_timestampsJson[scope] or= {}
    @_timestampsJson[scope] = {} if clearScope == true

    @_timestampsJson[scope]

  readTimestampsFile: ->
    try
      @g.file.readJSON(
        @eac.appConfig.tmp.assetsTimestampsFile,
        { encoding: 'utf-8' }
      )
    catch e
      {}

  writeTimestampsFile: ->
    @getTimestampsJson()
    mapping = JSON.stringify(@_timestampsJson, null, 4)

    @g.file.write(
      @eac.appConfig.tmp.assetsTimestampsFile,
      mapping,
      { encoding: 'utf-8' }
    )
