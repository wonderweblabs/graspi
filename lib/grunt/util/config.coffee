_                 = require './lodash_extensions'
AppConfig         = require './config_app'

configs = {}

module.exports = (grunt, configFile) ->
  if grunt.file.exists(configFile) == false
    grunt.fail.fatal("graspi: missing config file - #{configFile}")
  else if _.isEmpty(configs[configFile]) || !_.isObject(configs[configFile])
    configs[configFile] = new GraspiConfig(grunt, configFile)

  return configs[configFile]

class GraspiConfig

  constructor: (grunt, configFile) ->
    @grunt        = grunt
    @configFile   = configFile

    @buildConfig()
    @buildAppConfigs()

  getDefaults: ->
    environments: []
    apps: {}
    assetHost: ''
    tmp:
      css:            'tmp/grunt/css'
      js:             'tmp/grunt/js'
      images:         'tmp/grunt/images'
      filerevision:   'tmp/grunt/filerevision'
      filerev:        'tmp/grunt/filerev'
    bowerConcat:
      enabled:        true
      include:        []
      exclude:        []
      dependencies:   {}
      mainFiles:      []
    cssSass:
      enabed:         true
      trace:          false
      compass:        false
      debugInfo:      false
      lineNumbers:    false
      cacheLocation:  'tmp/grunt/sass_cache'
      precision:      10
      quiet:          false
      sourcemap:      'auto'
      style:          'compressed'
      update:         true
      loadPath:       []
    cssMinify:
      enabled:        false
      report:         'min'
      sourceMap:      true
      cleanCss:
        advanced:               false
        aggressiveMerging:      false
        compatibility:          '*'
        keepBreaks:             false
        keepSpecialComments:    0
        mediaMerging:           true
        rebase:                 false
        restructuring:          true
        roundingPrecision:      -1
        semanticMerging:        false
        shorthandCompacting:    false
        sourceMapInlineSources: false
    jsCoffee:
      enabled:    true
      bare:       false
      uglify:     false
      sourceMap:  true
    jsUglify:
      enabled:    false
      report:     'min'
      sourceMap:  true
      options:
        mangle:               false
        beautify:             false
        maxLineLen:           32000
        ASCIIOnly:            false
        exportAll:            false
        preserveComments:     'all'
        banner:               ''
        footer:               ''
        screwIE8:             false
        mangleProperties:     false
        reserveDOMProperties: false
        nameCache:            'tmp/grunt/coffee_mangle_cache.json'
        quoteStyle:           0
    imageMin:
      enabled:                true
      gifInterlaced:          false
      jpegProgressive:        false
      pngOptimizationLevel:   0
      jpegRecompressPlugin:
        enabled:        false
        loops:          6
        accurate:       true
        quality:        'veryhigh'
        method:         'ssim'
        target:         0.9999
        min:            60
        max:            99
        defish:         0
        progressive:    true
        subsample:      'default'
    filerevision:
      enabled: false
      manifest:
        prettyPrint: true
    manifest:
      enabled:      true
      prettyPrint:  true
      path:         'public/assets/g-assets.json'
      fileReplacePattern:
        pattern: '^(\/)?public\/assets\/g\-development(\/)?'
        replace: ''
      pathReplacePattern:
        pattern: '^(\/)?public\/'
        replace: ''
    watch:
      enabled: true
      options:
        livereload:   35729
        spawn:        false
        reload:       false
      gruntfile:
        files: ['Gruntfile.coffee']
    browserSync:
      enabled:      true
      bsFiles:      {}
      options:
        watchTask:      true
        ui:
          port:           3001
          weinre:
            port:           8080
        server:         false
        proxy:          false
        port:           3002
        https:          undefined
        ghostMode:
          clicks:         true
          scroll:         true
          forms:
            submit:         true
            inputs:         true
            toggles:        true
        logLevel:       'info'
        logPrefix:      'BS'
        logConnections: false
        logFileChanges: true
        logSnippet:     true
        snippetOptions:
          async:          true
          whitelist:      []
          blacklist:      []
          rule:
            match:          /<body[^>]*>/i
            fn: (snippet, match) ->
              match + snippet
        rewriteRules:   false
        tunnel:         null
        online:         null
        open:           false
        browser:        'default'
        xip:            false
        reloadOnRestart: false
        notify:         true
        scrollProportionally: true
        scrollThrottle: 0
        scrollRestoreTechnique: 'window.name'
        reloadDelay:    0
        reloadDebounce: 0
        plugins:        []
        injectChanges:  true
        startPath:      null
        minify:         true
        host:           null
        codeSync:       true
        timestamps:     true
        scriptPath:     undefined
        socket:
          path:           '/browser-sync/socket.io'
          clientPath:     '/browser-sync'
          namespace:      '/browser-sync'
          domain:         undefined
          clients:
            heartbeatTimeout: 5000

    tasks:
      gt_stylesheets: [
        'graspi_css_copy'
        'graspi_css_sass_compile'
        'graspi_css_concat'
        'graspi_css_minify'
        'graspi_filerev'
        'graspi_manifest'
        'graspi_css_replace_urls'
      ]
      gt_css: [
        'graspi_css_copy'
        'graspi_css_concat'
        'graspi_css_minify'
        'graspi_filerev'
        'graspi_manifest'
        'graspi_css_replace_urls'
      ]
      gt_sass: [
        'graspi_css_sass_compile'
        'graspi_css_concat'
        'graspi_css_minify'
        'graspi_filerev'
        'graspi_manifest'
        'graspi_css_replace_urls'
      ]
      gt_scripts: [
        'graspi_js_copy'
        'graspi_js_coffee_compile'
        'graspi_js_concat'
        'graspi_js_uglify'
      ]
      gt_js: [
        'graspi_js_copy'
        'graspi_js_concat'
        'graspi_js_uglify'
      ]
      gt_coffee: [
        'graspi_js_coffee_compile'
        'graspi_js_concat'
        'graspi_js_uglify'
      ]


  getBaseConfig: ->
    @baseConfig or= {}

  getConfig: ->
    @configObject or= {}

  getAppConfigs: ->
    @appConfigsObject or= {}

  getEnvironment: (env_name) ->
    @getConfig()[env_name]

  getApp: (env_name, app_name) ->
    return null unless _.isObject(@getAppConfigs()[app_name])

    @getAppConfigs()[app_name].getConfig(env_name)

  getYamlFileConfig: ->
    try
      yaml = @grunt.file.readYAML(@configFile)
    finally
      yaml or= {}

    yaml

  buildConfig: ->
    resultConfig  = {}
    configYaml    = @getYamlFileConfig()
    baseConfig    = _.mergeRecursive(@getDefaults(), configYaml)
    @baseConfig   = _.mergeRecursive(@getDefaults(), configYaml)

    _.each baseConfig.environments, (env) =>
      delete baseConfig[env]

    _.each baseConfig.environments, (env) =>
      resultConfig[env] = _.mergeRecursive(baseConfig, (configYaml[env] || {}))

    @configObject = resultConfig

  buildAppConfigs: ->
    _.each @getConfig(), (env, env_name) =>
      _.each env.apps, (app, app_name) =>
        @getAppConfigs()[app_name] = new AppConfig(@grunt, @getConfig(), app_name)

