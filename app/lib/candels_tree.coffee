DecisionTree = require 'lib/decision_tree'

CandelsTree = new DecisionTree 'candels', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @answer 'Smooth', leadsTo: 'How rounded is it?', icon: 'smooth_round'
    @answer 'Features or disk', leadsTo: 'Does the galaxy have a mostly clumpy appearance?', icon: 'feature'
    @answer 'Star or artifact', icon: 'star'
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Completely round', icon: 'smooth_round'
    @answer 'In between', icon: 'smooth_in-between'
    @answer 'Cigar shaped', icon: 'smooth_cigar'
  
  @question 'Clumps', 'Does the galaxy have a mostly clumpy appearance?', ->
    @answer 'Yes', leadsTo: 'How many clumps are there?', icon: 'yes'
    @answer 'No', leadsTo: 'Could this be a disk viewed edge-on?', icon: 'no'
  
  @question 'Clumps', 'How many clumps are there?', leadsTo: 'Do the clumps appear in a straight line, a chain, or a cluster?', ->
    @answer '1', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'clump_1'
    @answer '2', leadsTo: 'Is there one clump which is clearly brighter than the others?', icon: 'clump_2'
    @answer '3', icon: 'clump_3'
    @answer '4', icon: 'clump_4'
    @answer 'More than 4', icon: 'clump_4-plus'
    @answer "Can't tell", icon: 'clump_cant-tell'
  
  @question 'Clumps', 'Do the clumps appear in a straight line, a chain, or a cluster?', leadsTo: 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'Straight Line', icon: 'clump_line'
    @answer 'Chain', icon: 'clump_chain'
    @answer 'Cluster', icon: 'clump_cluster'
    @answer 'Spiral', icon: 'clump_spiral'
  
  @question 'Clumps', 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'Yes', leadsTo: 'Is the brightest clump central to the galaxy?', icon: 'yes'
    @answer 'No', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'no'
  
  @question 'Clumps', 'Is the brightest clump central to the galaxy?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy appear symmetrical?', icon: 'yes'
    @answer 'No', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', icon: 'no'
  
  @question 'Symmetry', 'Does the galaxy appear symmetrical?', leadsTo: 'Do the clumps appear to be embedded within a larger object?', ->
    @answer 'Yes', icon: 'yes'
    @answer 'No', icon: 'no'
  
  @question 'Clumps', 'Do the clumps appear to be embedded within a larger object?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Yes', icon: 'yes'
    @answer 'No', icon: 'no'
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its centre?', icon: 'yes'
    @answer 'No', leadsTo: 'Is there a sign of a bar feature through the centre of the galaxy?', icon: 'no'
  
  @question 'Bulge', 'Does the galaxy have a bulge at its centre?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Yes', icon: 'yes'
    @answer 'No', icon: 'no'
  
  @question 'Bar', 'Is there a sign of a bar feature through the centre of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Bar', icon: 'yes'
    @answer 'No bar', icon: 'no'
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?', icon: 'yes'
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', icon: 'no'
  
  @question 'Spiral', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @answer 'Tight', icon: 'spiral_tight'
    @answer 'Medium', icon: 'spiral_medium'
    @answer 'Loose', icon: 'spiral_loose'
  
  @question 'Spiral', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @answer '1', icon: 'spiral_1'
    @answer '2', icon: 'spiral_2'
    @answer '3', icon: 'spiral_3'
    @answer '4', icon: 'spiral_4'
    @answer 'More than 4', icon: 'spiral_4-plus'
    @answer "Can't tell", icon: 'spiral_cant-tell'
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'No bulge', icon: 'bulge_none'
    @answer 'Obvious', icon: 'bulge_obvious'
    @answer 'Dominant', icon: 'bulge_dominant'
  
  @question 'Merger', 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Merging', icon: 'merger'
    @answer 'Tidal debris', icon: 'tidal-debris'
    @answer 'Both', icon: 'merger_tidal'
    @answer 'Neither', icon: 'no'

module.exports = CandelsTree
