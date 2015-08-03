module.exports = class FileChecksum

  constructor: (fs, crypto, grunt) ->
    @g      = grunt
    @fs     = fs
    @crypto = crypto

  hexDigest: (file, length = 64, algorithm = 'sha256') ->
    return null unless @g.file.exists(file)
    return null unless @g.file.isFile(file)

    hash = @crypto.createHash(algorithm).update(@fs.readFileSync(file)).digest('hex')

    hash.slice(0, length)
