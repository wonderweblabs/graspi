module.exports = class TaskHelper extends require('./abstract')

  getCacheKey: ->
    "css-replace_urls-#{@eac.env_name}-#{@eac.app_name}"

  getGruntTask: ->
    'replace'

  getGruntTaskTarget: ->
    "graspi-css-replace_urls-#{super()}"

  isEnabled: ->
    return false unless super() == true
    return false unless @getConfig().manifest.enabled == true
    return false unless @fileCacheHasChanged(@getDestFilePath())

    true

  getManifestMapping: ->
    try
      mapping = @grunt.file.readJSON(@getConfig().manifest.path)
    mapping or= {}

    mapping[@eac.env_name] || {}

  getAssetHost: ->
    @getConfig().assetHost

  buildConfig: ->
    mapping = @getManifestMapping()

    cfg                                 = {}
    cfg.options                         = {}
    cfg.options.patterns                = []
    cfg.options.patterns.push {
      match: /image\-url\((\'|\")(.*)(\'|\")\)/g
      replacement: (match) =>
        result = match.replace(/image\-url\((\'|\")/g, '')
        result = result.replace(/(\'|\")\)/g, '')

        return match if @_.isEmpty(mapping[result])

        result = mapping[result]

        unless @_.isEmpty(@getAssetHost())
          host = @getAssetHost().replace(/\/$/, '')
          result = "#{host}/#{result}"

        "url('#{result}')"
    }

    cfg.files = []
    cfg.files.push {
      expand: true
      src: [@getDestFilePath()]
    }

    cfg