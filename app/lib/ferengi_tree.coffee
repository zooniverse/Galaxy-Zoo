DecisionTree = require 'lib/decision_tree'

FerengiTree = new DecisionTree 'ferengi', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @help "The aim here is to divide featureless galaxies from all the rest. If you can see any interesting features at all, click &quot;features or disk.&quot; Just occasionally you might see something that isn't a galaxy at all - the long streak of a satellite, for example, or a image swamped by light from a bright star. If this happens, just click &quot;star or artifact&quot;. Click to see larger images."
    @answer 'Smooth', leadsTo: 'How rounded is it?', icon: 'smooth_round', examples: 0
    @answer 'Features or disk', leadsTo: 'Does the galaxy have a mostly clumpy appearance?', icon: 'feature_clumpy', examples: 0
    @answer 'Star or artifact', leadsTo: 'Would you like to discuss this object?', icon: 'star', examples: 0
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is there anything odd?', ->
    @help "Not all galaxies are perfectly round - just look at the overall shape and put it in one of these three categories. If there's more than one galaxy in the field, remember always to concentrate on the one in the centre. Click to see larger images."
    @answer 'Completely round', icon: 'smooth_round', examples: 0
    @answer 'In between', icon: 'smooth_in-between', examples: 0
    @answer 'Cigar shaped', icon: 'smooth_cigar', examples: 0
  
  @question 'Clumps', 'Does the galaxy have a mostly clumpy appearance?', ->
    @help "Some galaxies are nothing but bright clumps. We don't mean those that have other features with a few small clusters of stars, but rather those that are made up mostly of bright clumps. Click to see larger images."
    @answer 'Yes', leadsTo: 'How many clumps are there?', icon: 'yes', examples: 0
    @answer 'No', leadsTo: 'Could this be a disk viewed edge-on?', icon: 'no', examples: 0
  
  @question 'Clumps', 'How many clumps are there?', leadsTo: 'Do the clumps appear in a straight line, a chain, or a cluster?', ->
    @help "Count the clumps! If there are more than 4, than don't worry about it - just click &quot;more than 4.&quot;"
    @answer '1', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'clump_1', examples: 0
    @answer '2', leadsTo: 'Is there one clump which is clearly brighter than the others?', icon: 'clump_2', examples: 0
    @answer '3', icon: 'clump_3', examples: 0
    @answer '4', icon: 'clump_4', examples: 0
    @answer 'More than 4', icon: 'clump_4-plus', examples: 0
    @answer "Can't tell", icon: 'clump_cant-tell', examples: 0
  
  @question 'Clumps', 'Do the clumps appear in a straight line, a chain, or a cluster?', leadsTo: 'Is there one clump which is clearly brighter than the others?', ->
    @help "Sometimes the clumps appear in a regular pattern - if so, then click the appropriate symbol."
    @answer 'Straight Line', icon: 'clump_line', examples: 0
    @answer 'Chain', icon: 'clump_chain', examples: 0
    @answer 'Cluster / Irregular', icon: 'clump_cluster', examples: 0
    @answer 'Spiral', icon: 'clump_spiral', examples: 0
  
  @question 'Clumps', 'Is there one clump which is clearly brighter than the others?', ->
    @help "Sometimes one clump dominates the scene. If so, click yes, otherwise, no."
    @answer 'Yes', leadsTo: 'Is the brightest clump central to the galaxy?', icon: 'yes', examples: 0
    @answer 'No', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'no', examples: 0
  
  @question 'Clumps', 'Is the brightest clump central to the galaxy?', ->
    @help "For very clumpy galaxies it may be difficult to tell, but make your best guess whether that brightest clump lies at the centre of the system or not."
    @answer 'Yes', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'yes', examples: 0
    @answer 'No', leadsTo: 'Is there anything odd?', icon: 'no', examples: 0
  
  @question 'Symmetry', 'Does the galaxy appear symmetrical?', leadsTo: 'Do the clumps appear to be embedded within a larger object?', ->
    @help "Are both halves of the galaxy the same? Or is one side disrupted or different in some way?"
    @answer 'Yes', icon: 'yes', examples: 0
    @answer 'No', icon: 'no', examples: 0
  
  @question 'Clumps', 'Do the clumps appear to be embedded within a larger object?', leadsTo: 'Is there anything odd?', ->
    @help "Look carefully for faint background light surrounding the clumps - are they embedded in a visible galaxy?"
    @answer 'Yes', icon: 'yes', examples: 0
    @answer 'No', icon: 'no', examples: 0
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @help "Disc galaxies are very thin, so look different when viewed from the side. We're trying to find exactly edge-on galaxies with this question. If the galaxy looks needle-like, perhaps with a bulge at the centre, then click &quot;yes,&quot; otherwise choose &quot;no&quot; (even for galaxies almost edge-on). Click to see larger images."
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its center? If so, what shape?', icon: 'yes', examples: 0
    @answer 'No', leadsTo: 'Is there any sign of a bar feature through the centre of the galaxy?', icon: 'no', examples: 0
  
  @question 'Bulge', 'Does the galaxy have a bulge at its center? If so, what shape?', leadsTo: 'Is there anything odd?', ->
    @help "Concentrate on the centre of the galaxy - if it has a smooth, uninterrupted, needle or lens-shape then click &quot;no bulge.&quot; Otherwise your options are &quot;rounded&quot; bulge or &quot;boxy&quot; (but boxy bulges are rare). Click to see larger images."
    @answer 'Rounded', icon: 'edge_round', examples: 0
    @answer 'Boxy', icon: 'edge_boxy', examples: 0
    @answer 'No bulge', icon: 'edge_none', examples: 0
  
  @question 'Bar', 'Is there any sign of a bar feature through the centre of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @help "Sometimes galaxies have a prominent straight &quot;bar&quot; running through their centre, and that's what we're looking for here. Click to see larger images."
    @answer 'Bar', icon: 'yes', examples: 0
    @answer 'No bar', icon: 'no', examples: 0
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @help "Look carefully for spiral arms - remember they may be embedded in the disk and not that easy to see. Click to see larger images."
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?', icon: 'yes', examples: 0
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', icon: 'no', examples: 0
  
  @question 'Spiral', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @help "Astronomers classify galaxies by how tight their arms are - you might find it easiest to see closest to the centre. Click to see larger images."
    @answer 'Tight', icon: 'spiral_tight', examples: 0
    @answer 'Medium', icon: 'spiral_medium', examples: 0
    @answer 'Loose', icon: 'spiral_loose', examples: 0
  
  @question 'Spiral', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @help "Some spiral galaxies are rather complicated, so don't be afraid to use the &quot;more than 4&quot; or &quot;can't tell&quot; buttons here."
    @answer '1', icon: 'spiral_1', examples: 0
    @answer '2', icon: 'spiral_2', examples: 0
    @answer '3', icon: 'spiral_3', examples: 0
    @answer '4', icon: 'spiral_4', examples: 0
    @answer 'More than 4', icon: 'spiral_4-plus', examples: 0
    @answer "Can't tell", icon: 'spiral_cant-tell', examples: 0
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is there anything odd?', ->
    @help "It's not always easy to tell, but look at the centre of the galaxy for a round bulge of stars which may obscure any bar and the spiral arms in this central region. Click to see larger images."
    @answer 'No bulge', icon: 'bulge_none', examples: 0
    @answer 'Obvious', icon: 'bulge_obvious', examples: 0
    @answer 'Dominant', icon: 'bulge_dominant', examples: 0
  
  @question 'Discuss', 'Would you like to discuss this object?', ->
    @help "If you have any questions about this object, or think it may be interesting to others, or just have something to say, you can start a discussion on Talk by clicking &quot;Yes&quot;. Talk will open in a new window - just close it to come back to the classification page."
    @answer 'Yes', icon: 'yes', talk: true, examples: 0
    @answer 'No', icon: 'no', examples: 0
  
  @question 'Odd', 'Is there anything odd?', ->
    @help "We're looking for signs that the galaxy is merging, is disturbed, or has other unusual features. Click to see larger images."
    @answer 'Yes', leadsTo: 'What are the odd features?', icon: 'yes', examples: 0
    @answer 'No', leadsTo: 'Would you like to discuss this object?', icon: 'no', examples: 0
  
  @question 'Odd', 'What are the odd features?', ->
    @checkbox 'Ring', icon: 'ring', examples: 0
    @checkbox 'Lens or arc', icon: 'lens', examples: 0
    @checkbox 'Disturbed', icon: 'disturbed', examples: 0
    @checkbox 'Irregular', icon: 'irregular', examples: 0
    @checkbox 'Other', icon: 'other', examples: 0
    @checkbox 'Merger', icon: 'merger', examples: 0
    @checkbox 'Dust lane', icon: 'dustlane', examples: 0
    @answer 'Done', leadsTo: 'Would you like to discuss this object?', icon: 'yes', examples: 0

module.exports = FerengiTree
