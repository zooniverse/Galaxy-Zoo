$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
Analytics = require 'lib/analytics'

# CONSTANTS #

###
The URL of the experiment server to use
###
# prod:
# EXPERIMENT_SERVER_URL = "http://experiments.zooniverse.org"
# dev:
EXPERIMENT_SERVER_URL = "http://localhost:4567"

###
Experiment Name
###
EXPERIMENT_NAME = "Zooniverse-MSR-BGU GalaxyZoo Experiment 1"

# VARIABLES #

###
The most recently detected intervention that has been detected and is yet to be processed. This should be set to null once delivered.
###
nextIntervention = null

###
The most recently detected intervention. This is never set to null.
###
lastDetectedIntervention = null

###
The most recently delivered intervention.
###
lastDeliveredIntervention = null

###
The most recently completed intervention (delivered + presentation_duration elapsed).
###
lastCompletedIntervention = null

###
The most recently dismissed intervention (delivered + user dismissed it prior to presentation_duration).
###
lastDismissedIntervention = null

###
local cache of current Subject ID, for use in logging
###
currentSubjectID = null

isInterventionNeeded = =>
  nextIntervention?

getNextIntervention = =>
  nextIntervention

setReadyForNextIntervention = =>
  nextIntervention = null

setNextIntervention = (intervention) =>
  nextIntervention = intervention

# method to check for a new intervention, and set it into variable ready for delivery. Intended to be polled.
checkForAndProcessIntervention = (subjectID) =>
  currentSubjectID = subjectID
  if !nextIntervention?
    $.ajax "#{EXPERIMENT_SERVER_URL}/users/#{User.current?.zooniverse_id}/interventions",
        success  : (res, status, xhr) =>
          interventions = res.interventions
          if interventions.length > 0
            setNextIntervention interventions[0]
            logInterventionDetected nextIntervention
        error    : (xhr, status, err) =>
          Analytics.logError {
            errorCode: "I04:"+status.toString()
            errorDescription: err.toString
          }
  else
    # there is already an intervention waiting to be delivered, do nothing until next poll

# record this user's permanent opt out with the experiment server.
performOptOut = =>
  $.ajax {
    url: "#{EXPERIMENT_SERVER_URL}/users/#{User.current?.zooniverse_id}/optout"
    type: 'POST'
    data: {project: "galaxy_zoo", experiment_name: EXPERIMENT_NAME}
    success: (res) =>
      logOptOut()
    error: (xhr, status, err) =>
      Analytics.logError {
        errorCode: "I06:" + status.toString
        errorDescription: err.toString
      }
  }

formatDate = (sourceDate) ->
  d = sourceDate.getDate()
  m = sourceDate.getMonth()+1
  y = sourceDate.getFullYear()
  h = sourceDate.getHours()
  min = sourceDate.getMinutes()
  s = sourceDate.getSeconds()
  y + "-" + m + "-" + d + " " + h + ":" + min + ":" + s

# log user opt out to Geordi and to BGU
logOptOut = =>
  geordiEventType = "interventionOptOut"
  # log to Geordi
  Analytics.logEvent {
              projectToken: nextIntervention.project
              experiment: nextIntervention.experiment_name
              cohort: nextIntervention.cohort_id
              userID: nextIntervention.user_id
              subjectID: currentSubjectID
              type: geordiEventType
              relatedID: nextIntervention.id # intervention id
            }
  # log to BGU server
  eventType = "optOut"
  bgu_payload =
    "source" : "galaxy_zoo"
    "event_type" : eventType
    "timestamp": formatDate(new Date())
    "user_id": nextIntervention.user_id
    "experiment_name": nextIntervention.experiment_name
    "project": nextIntervention.project
    "additional_info": ""

  $.ajax {
    url: 'http://lassi.ise.bgu.ac.il/add_event/'
    type: 'POST'
    contentType: 'application/json; charset=utf-8'
    data: JSON.stringify(bgu_payload)
    dataType: 'json'
    error: (xhr, status, err) =>
      Analytics.logError {
        errorCode: "I07:" + status.toString
        errorDescription: err.toString
      }
  }

# log next intervention as detected
logInterventionDetected = =>
  lastDetectedIntervention = nextIntervention
  Analytics.logEvent {
              projectToken: nextIntervention.project
              experiment: nextIntervention.experiment_name
              cohort: nextIntervention.cohort_id
              userID: nextIntervention.user_id
              subjectID: currentSubjectID
              type: "interventionDetected"
              relatedID: nextIntervention.id # intervention id
            }

# log next intervention as delivered (and notify experiment server)
logInterventionDelivered = =>
  if nextIntervention?
    Analytics.logEvent {
                projectToken: nextIntervention.project
                experiment: nextIntervention.experiment_name
                cohort: nextIntervention.cohort_id
                userID: nextIntervention.user_id
                subjectID: currentSubjectID
                type: "interventionDelivered"
                relatedID: nextIntervention.id # intervention id
              }
    lastDeliveredIntervention = nextIntervention
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/delivered"
  else
    Analytics.logError {
      errorCode: "I03"
      errorDescription: "No next intervention available to mark as delivered."
    }

# log next intervention as dismissed (and notify experiment server)
logInterventionDismissed = =>
  if lastDeliveredIntervention?
    Analytics.logEvent {
                projectToken: lastDeliveredIntervention.project
                experiment: lastDeliveredIntervention.experiment_name
                cohort: lastDeliveredIntervention.cohort_id
                userID: lastDeliveredIntervention.user_id
                subjectID: currentSubjectID
                type: "interventionDismissed"
                relatedID: lastDeliveredIntervention.id # intervention id
              }
    lastDismissedIntervention = lastDeliveredIntervention
    setReadyForNextIntervention()
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/dismissed"
  else
    Analytics.logError {
      errorCode: "I01"
      errorDescription: "No recently delivered intervention available to mark as complete."
    }

# log when the user has followed the link to talk displayed in one of the intervention messages
exitToTalk = =>
  if nextIntervention?
    Analytics.logEvent {
                projectToken: nextIntervention.project
                experiment: nextIntervention.experiment_name
                cohort: nextIntervention.cohort_id
                userID: nextIntervention.user_id
                subjectID: currentSubjectID
                type: "interventionExitToTalk"
                relatedID: nextIntervention.id # intervention id
              }
  else
    Analytics.logError {
      errorCode: "I05"
      errorDescription: "No next intervention available to use when logging exit to Talk."
    }
  window.location = "http://talk.galaxyzoo.org"

# log next intervention as completed (and notify server)
logInterventionCompleted = =>
  if lastDeliveredIntervention?
    Analytics.logEvent {
                projectToken: lastDeliveredIntervention.project
                experiment: lastDeliveredIntervention.experiment_name
                cohort: lastDeliveredIntervention.cohort_id
                userID: lastDeliveredIntervention.user_id
                subjectID: currentSubjectID
                type: "interventionCompleted"
                relatedID: lastDeliveredIntervention.id # intervention id
              }
    lastCompletedIntervention = lastDeliveredIntervention
    setReadyForNextIntervention()
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/completed"
  else
    Analytics.logError {
      errorCode: "I02"
      errorDescription: "No recently delivered intervention available to mark as complete."
    }

exports.checkForAndProcessIntervention = checkForAndProcessIntervention
exports.performOptOut = performOptOut
exports.logInterventionDetected = logInterventionDetected
exports.isInterventionNeeded = isInterventionNeeded
exports.getNextIntervention = getNextIntervention
exports.setReadyForNextIntervention = setReadyForNextIntervention
exports.logInterventionDelivered = logInterventionDelivered
exports.logInterventionDismissed = logInterventionDismissed
exports.logInterventionCompleted = logInterventionCompleted
exports.exitToTalk = exitToTalk
if lastDetectedIntervention?
  exports.currentProject = lastDetectedIntervention.project
  exports.currentExperimentName = lastDetectedIntervention.experiment_name
  exports.currentCohort = lastDetectedIntervention.cohort
  exports.currentRelatedId = lastDetectedIntervention.id
else
  exports.currentProject = "galaxy_zoo"
  exports.currentExperimentName = null
  exports.currentCohort = null
  exports.currentRelatedId = null
