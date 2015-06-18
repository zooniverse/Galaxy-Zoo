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

# method to check for a new intervention, and set it into variable ready for delivery. Intended to be polled.
checkForAndProcessIntervention = =>
  if !nextIntervention?
    $.ajax "#{EXPERIMENT_SERVER_URL}/users/#{User.current?.zooniverse_id}/interventions",
        success  : (res, status, xhr) ->
          if res.length > 0
            nextIntervention = res[0]
            logInterventionDetected nextIntervention
            console.log intervention
        error    : (xhr, status, err) ->
          Analytics.logError {
            userID: User.current?.zooniverse_id
            errorCode: status.toString
            errorDescription: err.toString
          }
  else
    # there is already an intervention waiting to be delivered, do nothing until next poll

# log intervention as detected
logInterventionDetected = (intervention) =>
  Analytics.logEvent {
              projectToken: intervention.project
              experiment: intervention.experiment_name
              cohort: intervention.cohort_id
              userID: intervention.user_id
              type: "interventionDetected"
              subjectID: intervention.preconfigured_id # message id
              relatedID: intervention.id # intervention id
            }

# log intervention as delivered (and notify experiment server)
logInterventionDelivered = (intervention) =>
  Analytics.logEvent {
              projectToken: intervention.project
              experiment: intervention.experiment_name
              cohort: intervention.cohort_id
              userID: intervention.user_id
              type: "interventionDelivered"
              subjectID: intervention.preconfigured_id # message id
              relatedID: intervention.id # intervention id
            }
  nextIntervention = null
  $.post '#{EXPERIMENT_SERVER_URL}/interventions/#{intervention.id}/delivered'

# log intervention as dismissed (and notify experiment server)
logInterventionDismissed = (intervention) =>
  Analytics.logEvent {
              projectToken: intervention.project
              experiment: intervention.experiment_name
              cohort: intervention.cohort_id
              userID: intervention.user_id
              type: "interventionDismissed"
              subjectID: intervention.preconfigured_id # message id
              relatedID: intervention.id # intervention id
            }
  nextIntervention = null
  $.post '#{EXPERIMENT_SERVER_URL}/interventions/#{intervention.id}/dismissed'

exports.checkForAndProcessIntervention = checkForAndProcessIntervention
exports.nextIntervention = nextIntervention
exports.logInterventionDetected = logInterventionDetected
exports.logInterventionDelivered = logInterventionDelivered
exports.logInterventionDismissed = logInterventionDismissed