$ = require 'jqueryify'
Subject = require 'models/subject'
UserGetter = require 'lib/userID'
Intervention = require 'lib/intervention'

buildEventData = (params) ->
  eventData = {}
  # defaults
  eventData['subjectID'] = Subject.current?.zooniverse_id
  eventData['relatedID'] = Intervention.currentRelatedId
  eventData['experiment'] = Intervention.currentExperimentName
  eventData['projectToken'] = Subject.projectName
  eventData['cohort'] = Intervention.currentCohort
  eventData['projectToken'] = "galaxy_zoo"
  eventData['userID'] = "(anonymous)"
  # set fields from params
  eventData['time'] = Date.now()
  eventData['projectToken'] = params.projectToken if params.projectToken?
  eventData['userID'] = params.userID if params.userID?
  eventData['subjectID'] = params.subjectID if params.subjectID?
  eventData['type'] = params.type
  eventData['relatedID'] = params.relatedID if params.relatedID?
  eventData['experiment'] = params.experiment if params.experiment?
  eventData['errorCode'] = ""
  eventData['errorDescription'] = ""
  eventData['cohort'] = params.cohort if params.cohort?
  eventData

addUserDetailsToEventData = (eventData) ->
  eventualUserIdentifier = new $.Deferred
  UserGetter.getUserIDorIPAddress()
  .then (data) =>
    if data?
      UserGetter.currentUserID = data
  .fail =>
    UserGetter.currentUserID = "(anonymous)"
  .always =>
    eventData['userID'] = UserGetter.currentUserID
    eventualUserIdentifier.resolve eventData
  eventualUserIdentifier.promise()

###
log event with Geordi v2
###
logToGeordi = (eventData) =>
  $.ajax {
    url: 'https://geordi.zooniverse.org/api/events/',
    type: 'POST',
    contentType: 'application/json; charset=utf-8',
    data: JSON.stringify(eventData),
    dataType: 'json'
  }

###
log event with Google Analytics
###
logToGoogle = (eventData) =>
  dataLayer.push {
    event: "gaTriggerEvent"
    project_token: eventData['projectToken']
    user_id: eventData['userID']
    subject_id: eventData['subjectID']
    geordi_event_type: eventData['type']
    classification_id: eventData['relatedID']
  }

###
This will log a user interaction both in the Geordi analytics API and in Google Analytics.
###
logEvent = (params) =>
  eventData = buildEventData(params)
  addUserDetailsToEventData(eventData)
  .always (eventData) =>
    logToGeordi eventData
    logToGoogle eventData

###
This will log an error in Geordi only.
###
logError = (params) ->
  eventData = buildEventData(params)
  eventData['errorCode'] = params.errorCode
  eventData['type'] = "error"
  eventData['errorDescription'] = params.errorDescription
  logToGeordi eventData

exports.logEvent = logEvent
exports.logError = logError