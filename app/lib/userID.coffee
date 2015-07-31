User = require 'zooniverse/lib/models/user'
currentUserID = null

getClientOrigin = ->
  eventualIP = new $.Deferred
  $.get('https://api.ipify.org')
  .then (ip) =>
    eventualIP.resolve {ip: ip, address: ip}
  .fail =>
    eventualIP.resolve {ip: '?.?.?.?', address: '(anonymous)'}
  eventualIP.promise()

getNiceOriginString = (data) ->
  if data.ip? && data.address?
    if data.ip == '?.?.?.?'
      "(anonymous)"
    else if data.ip == data.address
      "(#{ data.ip })"
    else
      "(#{ data.address } [#{ data.ip }])"
  else
    "(anonymous)"

getUserIDorIPAddress = =>
  eventualUserID = new $.Deferred
  if User.current?.zooniverse_id && currentUserID!=User.current?.zooniverse_id
    # if a current ID is stored, but user's current ID is something different (e.g. anon IP), overwrite previous
    currentUserID = User.current?.zooniverse_id
    eventualUserID.resolve User.current?.zooniverse_id
  else if currentUserID?
    eventualUserID.resolve currentUserID
  else if User.current?.zooniverse_id
    eventualUserID.resolve User.current?.zooniverse_id
  else
    getClientOrigin()
    .then (data) =>
      if data?
        currentUserID = getNiceOriginString data
    .always =>
      eventualUserID.resolve currentUserID
  eventualUserID.promise()

exports.getClientOrigin = getClientOrigin
exports.getNiceOriginString = getNiceOriginString
exports.getUserIDorIPAddress = getUserIDorIPAddress
exports.currentUserID = currentUserID