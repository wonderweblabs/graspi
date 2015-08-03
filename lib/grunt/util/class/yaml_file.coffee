module.exports = class YamlFileHandler

  constructor: (lodash, grunt) ->
    @_ = lodash
    @g = grunt

  read: (file) ->
    return {} unless @g.file.exists(file)

    try
      yaml = @g.file.readYAML(file, { encoding: 'utf-8' })
      yaml or= {}
      yaml = {} unless @_.isObject(yaml)

      return yaml
    catch e
      return {}
