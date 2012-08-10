_.mixin eachSlice: (obj, size, iterator, context) ->
  _(obj).tap ->
    list = if _(obj).isArray()
      obj
    else if _(obj).isObject()
      _.zip _(obj).keys(), _(obj).values()
    
    for i in [0...Math.ceil(list.length / size)]
      iterator.call context, list.slice(i * size, (i * size) + size), list

_.mixin inGroupsOf: (obj, size) ->
  _([]).tap (groups) ->
    _(obj).eachSlice size, (slice) -> groups.push slice

module.exports = _
