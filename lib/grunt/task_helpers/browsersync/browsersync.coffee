module.exports = class TaskHelper extends require('./abstract')

  isEnabled: ->
    return false unless super() == true
    return false unless @_.isObject(@getConfig().browserSync.bsFiles)

    @_.size(@getConfig().browserSync.bsFiles.src) > 0

  run: ->
    return unless @isEnabled()

    cfg = @g.config.get('browserSync') || {}
    cfg.options or= {}
    cfg.bsFiles or= []

    cfg.options = @_.merge {}, cfg.options, @buildBaseOptions()
    cfg.bsFiles = @_.uniq(cfg.bsFiles.concat(@buildSrcArray()))

    @g.config.merge({ browserSync: cfg })

  buildBaseOptions: ->
    @getConfig().browserSync.options || {}

  buildSrcArray: ->
    @getConfig().browserSync.bsFiles.src || []