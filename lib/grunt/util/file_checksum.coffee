_      = require 'lodash'
Fs     = require 'fs'
Crypto = require 'crypto'

module.exports = class FileChecksum

  constructor: (@grunt) ->

  hexDigest: (file, length = 64, algorithm = 'sha256') ->
    return null unless @grunt.file.exists(file)
    return null unless @grunt.file.isFile(file)

    hash = Crypto.createHash(algorithm).update(Fs.readFileSync(file)).digest('hex')

    hash.slice(0, length)

  stringHexDigest: (str, length = 64, algorithm = 'sha256') ->
    return null unless _.isString(str)

    hash = Crypto.createHash(algorithm).update(str).digest('hex')

    hash.slice(0, length)
