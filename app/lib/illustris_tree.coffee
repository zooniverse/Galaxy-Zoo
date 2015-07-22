DecisionTree = require 'lib/decision_tree'

IllustrisTree = new DecisionTree 'illustris', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @help "The aim here is to divide featureless galaxies from all the rest. If you can see any interesting features at all, click &quot;features or disk.&quot; Just occasionally you might see something that isn't a galaxy at all - the long streak of a satellite, for example, or an image swamped by light from a bright star. If this happens, just click &quot;star or artifact&quot;. Click to see larger images."
    @answer 'Smooth', leadsTo: 'How rounded is it?', icon: 'smooth_round', examples: 1
    @answer 'Features or disk', leadsTo: 'Could this be a disk viewed edge-on?', icon: 'feature', examples: 3
    @answer 'Star or artifact', leadsTo: 'Would you like to discuss this object?', icon: 'star', examples: 2
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @help "Disc galaxies are very thin, so look different when viewed from the side. We're trying to find exactly edge-on galaxies with this question. If the galaxy looks needle-like, perhaps with a bulge at the centre, then click &quot;yes,&quot; otherwise choose &quot;no&quot; (even for galaxies almost edge-on). Click to see larger images."
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its center? If so, what shape?', icon: 'yes', examples: 1
    @answer 'No', leadsTo: 'Is there any sign of a bar feature through the center of the galaxy?', icon: 'no', examples: 2
  
  @question 'Bar', 'Is there any sign of a bar feature through the center of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @help "Sometimes galaxies have a prominent straight &quot;bar&quot; running through their centre, and that's what we're looking for here. Click to see larger images."
    @answer 'Bar', icon: 'yes', examples: 4
    @answer 'No bar', icon: 'no', examples: 4
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @help "Look carefully for spiral arms - remember they may be embedded in the disk and not that easy to see. Click to see larger images."
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?', icon: 'yes', examples: 2
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', icon: 'no', examples: 1
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is there anything odd?', ->
    @help "It's not always easy to tell, but look at the centre of the galaxy for a round bulge of stars which may obscure any bar and the spiral arms in this central region. Click to see larger images."
    @answer 'No bulge', icon: 'bulge_none'
    @answer 'Just noticeable', icon: 'bulge_noticeable'
    @answer 'Obvious', icon: 'bulge_obvious'
    @answer 'Dominant', icon: 'bulge_dominant'
  
  @question 'Odd', 'Is there anything odd?', ->
    @help "We're looking for signs that the galaxy is merging, is disturbed, or has other unusual features. Click to see larger images."
    @answer 'Yes', leadsTo: 'What are the odd features?', icon: 'yes'
    @answer 'No', leadsTo: 'Would you like to discuss this object?', icon: 'no'
  
  @question 'Odd', 'What are the odd features?', ->
    @checkbox 'Ring', icon: 'ring', examples: 2
    @checkbox 'Lens or arc', icon: 'lens', examples: 1
    @checkbox 'Disturbed', icon: 'disturbed', examples: 3
    @checkbox 'Irregular', icon: 'irregular', examples: 2
    @checkbox 'Other', icon: 'other', examples: 3
    @checkbox 'Merger', icon: 'merger', examples: 6
    @checkbox 'Dust lane', icon: 'dustlane', examples: 2
    @answer 'Done', leadsTo: 'Would you like to discuss this object?', icon: 'yes'
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is there anything odd?', ->
    @answer 'Completely round', icon: 'smooth_round', examples: 1
    @answer 'In between', icon: 'smooth_in-between', examples: 1
    @answer 'Cigar shaped', icon: 'smooth_cigar', examples: 1
  
  @question 'Bulge', 'Does the galaxy have a bulge at its center? If so, what shape?', leadsTo: 'Is there anything odd?', ->
    @help "Concentrate on the centre of the galaxy - if it has a smooth, uninterrupted, needle or lens-shape then click &quot;no bulge.&quot; Otherwise your options are &quot;rounded&quot; bulge or &quot;boxy&quot; (but boxy bulges are rare). Click to see larger images."
    @answer 'Rounded', icon: 'edge_round', examples: 1
    @answer 'Boxy', icon: 'edge_boxy', examples: 1
    @answer 'No bulge', icon: 'edge_none', examples: 1
  
  @question 'Spiral', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @answer 'Tight', icon: 'spiral_tight', examples: 1
    @answer 'Medium', icon: 'spiral_medium', examples: 1
    @answer 'Loose', icon: 'spiral_loose', examples: 1
  
  @question 'Spiral', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @answer '1', icon: 'spiral_1', examples: 2
    @answer '2', icon: 'spiral_2', examples: 4
    @answer '3', icon: 'spiral_3', examples: 3
    @answer '4', icon: 'spiral_4', examples: 2
    @answer 'More than 4', icon: 'spiral_4-plus', examples: 2
    @answer "Can't tell", icon: 'spiral_cant-tell', examples: 3
  
  @question 'Discuss', 'Would you like to discuss this object?', ->
    @help "If you have any questions about this object, or think it may be interesting to others, or just have something to say, you can start a discussion on Talk by clicking &quot;Yes&quot;. Talk will open in a new window - just close it to come back to the classification page."
    @answer 'Yes', icon: 'yes', talk: true
    @answer 'No', icon: 'no'

module.exports = IllustrisTree
