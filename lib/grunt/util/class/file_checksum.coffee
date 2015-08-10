module.exports = class FileChecksum

  constructor: (@fs, @crypto, @grunt) ->

  hexDigest: (file, length = 64, algorithm = 'sha256') ->
    return null unless @grunt.file.exists(file)
    return null unless @grunt.file.isFile(file)

    hash = @crypto.createHash(algorithm).update(@fs.readFileSync(file)).digest('hex')

    hash.slice(0, length)
