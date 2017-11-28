User = require 'zooniverse/lib/models/user'
currentUserID = null

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
    eventualUserID.resolve "(anonymous)"
  eventualUserID.promise()

exports.getUserIDorIPAddress = getUserIDorIPAddress
exports.currentUserID = currentUserID