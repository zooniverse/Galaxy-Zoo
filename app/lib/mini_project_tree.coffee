DecisionTree = require 'lib/decision_tree'

MiniProjectTree = new DecisionTree 'mini_project', ->
  @question 'Galaxies', 'Is this an isolated galaxy, a galaxy with neighbors or a start or artifact', ->
    @help "The aim here is to divide featureless galaxies from all the rest. If you can see any interesting features at all, click &quot;features or disk.&quot; Just occasionally you might see something that isn't a galaxy at all - the long streak of a satellite, for example, or a image swamped by light from a bright star. If this happens, just click &quot;star or artifact&quot;. Click to see larger images."
    @answer 'Isolated galaxy', leadsTo: 'Does the central galaxy have tidal arms?', icon: 'isolated_galaxy', examples: 1
    @answer 'Neighbors', leadsTo: 'Are any neighbors touching the central galaxy?', icon: 'galaxy_neighbors', examples: 3
    @answer 'Star or artifact', leadsTo: 'Would you like to discuss this object?', icon: 'star', examples: 2
  
  @question 'Tidal Arms', 'Does the central galaxy have tidal arms?', ->
    @help "Tidal arms are indicators of inteaction between galaxies."
    @answer 'Yes', leadsTo: 'How large are the tidal arms?', icon: 'yes', examples: 1
    @answer 'No', leadsTo: 'Is the galaxy distributed or asymetric?', icon: 'no', examples: 2
  
  @question 'Tidal Arms Size', 'How large are the tidal arms?', leadsTo: 'In the center of the galaxy, are there more than 1 bright clumps?', ->
    @help "NEED HELP HERE"
    @answer 'Large', icon: 'large-tidal'
    @answer 'Small', icon: 'small-tidal'
  
  @question 'Disrupted', 'Is the galaxy distributed or asymetric?', leadsTo: 'In the center of the galaxy, are there more than 1 bright clumps?', ->
    @help "NEED HELP HERE"
    @answer 'Yes', icon: 'yes', examples: 2
    @answer 'No',  icon: 'no', examples: 1


  @question 'Tidal Stream', "Are any neighbors touching the central galaxy?", leadsTo: "Are any of the neighbors connected by tidal streams?", ->
    @help 'NEED HELP HERE'
    @answer 'Yes', icon: 'yes', examples: 2
    @answer 'No',  icon: 'no', examples: 1

  @question 'Touching', "Are any of the neighbors connected by tidal streams?", leadsTo: "Does the central galaxy have tidal arms?", ->
    @help 'NEED HELP HERE'
    @answer 'Yes', icon: 'yes', examples: 2
    @answer 'No',  icon: 'no', examples: 1
  
  @question 'Clumps', 'In the center of the galaxy, are there more than 1 bright clumps?', leadsTo: 'Is there anything odd?', ->
    @help "NEED HELP HERE"
    @answer '1', icon: 'clump_1'
    @answer '2', icon: 'clump_2'
    @answer '3', icon: 'clump_3'
    @answer '4', icon: 'clump_4'
  
  @question 'Spiral', 'Is the central galaxy a spiral galaxy?', ->
    @help "NEED HELP HERE"
    @answer 'Yes', icon: 'yes',  leadsTo: 'Is the central galaxy barbed?'
    @answer 'No', icon: 'no'

  @question 'Barbed', 'Is the central galaxy barbed?', ->
    @help "NEED HELP HERE"
    @answer 'Yes', icon: 'yes'
    @answer 'No', icon: 'no'
    
module.exports = MiniProjectTree
