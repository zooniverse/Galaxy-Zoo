Spine = require('spine')

class Interactive extends Spine.Controller

  events:
    'click .classify_galaxies': 'linkToGalaxyZoo'
    'click .choose_investigation': 'linkToChooseInvestigation'
    'click .my_galaxies': 'linkToMyGalaxies'
    'click .graph': 'linkToGraph'

  constructor: ->
    super
    home = require('views/interactive/home')
    @html home

  linkToGalaxyZoo: (ev) ->
    @navigate '/classify'

  linkToChooseInvestigation: (ev) ->
    @navigate '/navigator/choose_investigation'
    ev.preventDefault()

  linkToMyGalaxies: (ev) ->
    @navigate '/navigator/my_galaxies'
    ev.preventDefault()
    
  linkToGraph: (ev) ->
    @navigate '/navigator/graph'
    ev.preventDefault()      


module.exports = Interactive