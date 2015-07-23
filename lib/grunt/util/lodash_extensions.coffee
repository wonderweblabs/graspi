_ = require('lodash')

#
# Recursive merging
#
_.mergeRecursive = (objA, objB) ->
  _.merge {}, objA, objB, (a, b) =>
    return a.concat(b) if _.isArray(a)
    return _.mergeRecursive(a, b) if _.isObject(a) && !_.isRegExp(a) && !_.isRegExp(b)

#
# Better inject syntax
#
_.inject = (collection, memo, iteratee) ->
  _.reduce collection, iteratee, memo

# export
module.exports = _