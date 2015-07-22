DecisionTree = require 'lib/decision_tree'

DecalsTree = new DecisionTree 'decals', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @help "The aim here is to divide featureless galaxies from all the rest. If you can see any interesting features at all, click &quot;features or disk.&quot; Just occasionally you might see something that isn't a galaxy at all - the long streak of a satellite, for example, or an image swamped by light from a bright star. If this happens, just click &quot;star or artifact&quot;. Click to see larger images."
    @answer 'Smooth', leadsTo: 'How rounded is it?', icon: 'smooth_round', examples: 1
    @answer 'Features or disk', leadsTo: 'Could this be a disk viewed edge-on?', icon: 'feature_clumpy', examples: 2
    @answer 'Star or artifact', leadsTo: 'Would you like to discuss this object?', icon: 'star', examples: 3
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @help "Not all galaxies are perfectly round - just look at the overall shape and put it in one of these three categories. If there's more than one galaxy in the field, remember always to concentrate on the one in the centre. Click to see larger images."
    @answer 'Completely round', icon: 'smooth_round', examples: 1
    @answer 'In between', icon: 'smooth_in-between', examples: 1
    @answer 'Cigar shaped', icon: 'smooth_cigar', examples: 1
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @help "Disc galaxies are very thin, so look different when viewed from the side. We're trying to find exactly edge-on galaxies with this question. If the galaxy looks needle-like, perhaps with a bulge at the centre, then click &quot;yes,&quot; otherwise choose &quot;no&quot; (even for galaxies almost edge-on). Click to see larger images."
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its centre?', icon: 'yes', examples: 1
    @answer 'No', leadsTo: 'Is there any sign of a bar feature through the centre of the galaxy?', icon: 'no', examples: 1
  
  @question 'Bulge', 'Does the galaxy have a bulge at its centre?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @help "Look at the centre of the galaxy - is there any sign of a bulge of stars sticking out above and below the otherwise smooth shape? If so, click yes."
    @answer 'Yes', icon: 'yes', examples: 1
    @answer 'No', icon: 'no', examples: 1
  
  @question 'Bar', 'Is there any sign of a bar feature through the centre of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @help "Sometimes galaxies have a prominent straight &quot;bar&quot; running through their centre, and that's what we're looking for here. Click to see larger images."
    @answer 'Bar', icon: 'yes', examples: 6
    @answer 'No bar', icon: 'no', examples: 1
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @help "Look carefully for spiral arms - remember they may be embedded in the disk and not that easy to see. Click to see larger images."
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?', icon: 'yes', examples: 1
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', icon: 'no', examples: 1
  
  @question 'Spiral', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @help "Astronomers classify galaxies by how tight their arms are - you might find it easiest to see closest to the centre. Click to see larger images."
    @answer 'Tight', icon: 'spiral_tight', examples: 1
    @answer 'Medium', icon: 'spiral_medium', examples: 1
    @answer 'Loose', icon: 'spiral_loose', examples: 1
  
  @question 'Spiral', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @help "Some spiral galaxies are rather complicated, so don't be afraid to use the &quot;more than 4&quot; or &quot;can't tell&quot; buttons here."
    @answer '1', icon: 'spiral_1'
    @answer '2', icon: 'spiral_2'
    @answer '3', icon: 'spiral_3'
    @answer '4', icon: 'spiral_4'
    @answer 'More than 4', icon: 'spiral_4-plus'
    @answer "Can't tell", icon: 'spiral_cant-tell'
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @help "It's not always easy to tell, but look at the centre of the galaxy for a round bulge of stars which may obscure any bar and the spiral arms in this central region. Click to see larger images."
    @answer 'No bulge', icon: 'bulge_none', examples: 1
    @answer 'Obvious', icon: 'bulge_obvious', examples: 1
    @answer 'Dominant', icon: 'bulge_dominant', examples: 1
  
  @question 'Merger', 'Is the galaxy currently merging or is there any sign of tidal debris?', leadsTo: 'Would you like to discuss this object?', ->
    @help "Now you can look at the larger picture - if the galaxy is colliding with another, click &quot;merger.&quot; If there's no visible second system, but long streams of stars or gas are visible then click &quot;tidal debris.&quot; &quot;Both&quot; and &quot;Neither&quot; are your other options. Click to see larger images."
    @answer 'Merging', icon: 'merger', examples: 4
    @answer 'Tidal debris', icon: 'tidal-debris', examples: 1
    @answer 'Both', icon: 'merger_tidal', examples: 2
    @answer 'Neither', icon: 'no', examples: 1
  
  @question 'Merger', 'Is the galaxy currently merging or is there any sign of tidal debris?', leadsTo: 'Do you see any of these odd features in the image?', ->
    @help "Now you can look at the larger picture - if the galaxy is colliding with another, click &quot;merger.&quot; If there's no visible second system, but long streams of stars or gas are visible then click &quot;tidal debris.&quot; &quot;Both&quot; and &quot;Neither&quot; are your other options. Click to see larger images."
    @answer 'Merging', icon: 'merger', examples: 4
    @answer 'Tidal debris', icon: 'tidal-debris', examples: 1
    @answer 'Both', icon: 'merger_tidal', examples: 2
    @answer 'Neither', icon: 'no', examples: 1
  
  @question 'Odd', 'Do you see any of these odd features in the image?', ->
    @checkbox 'None', icon: 'ring', examples: 1
    @checkbox 'Ring', icon: 'ring', examples: 1
    @checkbox 'Lens or arc', icon: 'lens', examples: 1
    @checkbox 'Irregular', icon: 'irregular', examples: 1
    @checkbox 'Other', icon: 'other', examples: 1
    @checkbox 'Dust lane', icon: 'dustlane', examples: 2
    @answer 'Done', leadsTo: 'Would you like to discuss this object?', icon: 'yes'
  
  @question 'Discuss', 'Would you like to discuss this object?', ->
    @help "If you have any questions about this object, or think it may be interesting to others, or just have something to say, you can start a discussion on Talk by clicking &quot;Yes&quot;. Talk will open in a new window - just close it to come back to the classification page."
    @answer 'Yes', icon: 'yes', talk: true
    @answer 'No', icon: 'no'

module.exports = DecalsTree
