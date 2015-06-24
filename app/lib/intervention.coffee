$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
Classification = require 'models/classification'
Analytics = require 'lib/analytics'

# CONSTANTS #

###
The URL of the experiment server to use
###
# prod:
EXPERIMENT_SERVER_URL = "http://experiments.zooniverse.org"

# VARIABLES #

###
The most recently detected intervention that has been detected and is yet to be processed. This should be set to null once delivered.
###
nextIntervention = null

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

isInterventionNeeded = =>
  nextIntervention?

getNextIntervention = =>
  nextIntervention

setReadyForNextIntervention = =>
  nextIntervention = null

setNextIntervention = (intervention) =>
  nextIntervention = intervention

# method to check for a new intervention, and set it into variable ready for delivery. Intended to be polled.
checkForAndProcessIntervention = =>
  if !nextIntervention?
    $.ajax "#{EXPERIMENT_SERVER_URL}/users/#{User.current?.zooniverse_id}/interventions",
        success  : (res, status, xhr) =>
          if res.length > 0
            setNextIntervention res[0]
            logInterventionDetected nextIntervention
        error    : (xhr, status, err) =>
          Analytics.logError {
            userID: User.current?.zooniverse_id
            subjectID: Subject.current?.zooniverse_id # subject id
            errorCode: "I04:"+status.toString
            errorDescription: err.toString
          }
  else
    # there is already an intervention waiting to be delivered, do nothing until next poll

# log next intervention as detected
logInterventionDetected = =>
  Analytics.logEvent {
              projectToken: nextIntervention.project
              experiment: nextIntervention.experiment_name
              cohort: nextIntervention.cohort_id
              userID: nextIntervention.user_id
              type: "interventionDetected"
              subjectID: Subject.current?.zooniverse_id # subject id
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
                type: "interventionDelivered"
                subjectID: Subject.current?.zooniverse_id # subject id
                relatedID: nextIntervention.id # intervention id
              }
    lastDeliveredIntervention = nextIntervention
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/delivered"
  else
    Analytics.logError {
      userID: User.current?.zooniverse_id
      subjectID: Subject.current?.zooniverse_id # subject id
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
                type: "interventionDismissed"
                subjectID: Subject.current?.zooniverse_id # subject id
                relatedID: lastDeliveredIntervention.id # intervention id
              }
    lastDismissedIntervention = lastDeliveredIntervention
    setReadyForNextIntervention()
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/dismissed"
  else
    Analytics.logError {
      userID: User.current?.zooniverse_id
      subjectID: Subject.current?.zooniverse_id # subject id
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
                type: "interventionExitToTalk"
                subjectID: Subject.current?.zooniverse_id # subject id
                relatedID: nextIntervention.id # intervention id
              }
  else
    Analytics.logError {
      userID: User.current?.zooniverse_id
      subjectID: Subject.current?.zooniverse_id # subject id
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
                type: "interventionCompleted"
                subjectID: Subject.current?.zooniverse_id # subject id
                relatedID: lastDeliveredIntervention.id # intervention id
              }
    lastCompletedIntervention = lastDeliveredIntervention
    setReadyForNextIntervention()
    $.post "#{EXPERIMENT_SERVER_URL}/interventions/#{lastDeliveredIntervention.id}/completed"
  else
    Analytics.logError {
      userID: User.current?.zooniverse_id
      subjectID: Subject.current?.zooniverse_id # subject id
      errorCode: "I02"
      errorDescription: "No recently delivered intervention available to mark as complete."
    }

exports.checkForAndProcessIntervention = checkForAndProcessIntervention
exports.logInterventionDetected = logInterventionDetected
exports.isInterventionNeeded = isInterventionNeeded
exports.getNextIntervention = getNextIntervention
exports.setReadyForNextIntervention = setReadyForNextIntervention
exports.logInterventionDelivered = logInterventionDelivered
exports.logInterventionDismissed = logInterventionDismissed
exports.logInterventionCompleted = logInterventionCompleted
exports.exitToTalk = exitToTalk

