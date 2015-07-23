module.exports = class TaskHelper extends require('./abstract')

  isEnabled: ->
    return false unless super() == true

    @_.isObject(@getConfig().watch.groups)

  run: ->
    return unless @isEnabled()

    cfg = @g.config.get('watch') || {}
    cfg = @_.merge {}, cfg, @buildConfig()

    @g.config.merge({ watch: cfg })

  buildConfig: ->
    @setBaseWatchConfig()

    cfg = {}

    @_.each @getConfig().watch.groups, (group, group_name) =>
      group_name = "#{@eac.env_name}-#{@eac.app_name}-#{group_name}"

      cfg[group_name]                 = {}
      cfg[group_name].options         = {}
      cfg[group_name].options.spawn   = @getConfig().watch.options.spawn
      cfg[group_name].options.reload  = @getConfig().watch.options.reload
      cfg[group_name].files           = group.files
      cfg[group_name].tasks           = @_.map group.tasks, (task) =>
        "#{task}:#{@eac.env_name}:#{@eac.app_name}"

    cfg

  setBaseWatchConfig: ->
    cfg                     = {}
    cfg.options             = {}
    cfg.options.forever     = true
    cfg.options.livereload  = @getConfig().watch.options.livereload

    @g.config.merge({ watch: cfg })
