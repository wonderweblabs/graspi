module.exports = class JsonFileHandler

  constructor: (lodash, grunt) ->
    @_ = lodash
    @g = grunt

  read: (file) ->
    return {} unless @g.file.exists(file)

    try
      json = @g.file.readJSON(file, { encoding: 'utf-8' })
      json or= {}
      json = {} unless @_.isObject(json)

      return json
    catch e
      return {}

  write: (file, json, prettyPrint = true) ->
    return unless @_.isObject(json)

    spaces  = if prettyPrint == true then 4 else 0
    json    = JSON.stringify(json, null, spaces)

    @g.file.write(file, json, { encoding: 'utf-8' })