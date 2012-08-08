DecisionTree = require 'lib/decision_tree'

SloanTree = new DecisionTree 'sloan', ->
  @question 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @answer 'Smooth', leadsTo: 'How rounded is it?'
    @answer 'Features or disk', leadsTo: 'Does the galaxy have a mostly clumpy appearance?'
    @answer 'Star or artifact'
  
  @question 'How rounded is it?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Completely round'
    @answer 'In between'
    @answer 'Cigar shaped'
  
  @question 'Does the galaxy have a mostly clumpy appearance?', ->
    @answer 'Yes', leadsTo: 'How many clumps are there?'
    @answer 'No', leadsTo: 'Could this be a disk viewed edge-on?'
  
  @question 'How many clumps are there?', leadsTo: 'Do the clumps appear in a straight line, a chain, or a cluster?', ->
    @answer '1', leadsTo: 'Does the galaxy appear symmetrical?'
    @answer '2', leadsTo: 'Is there one clump which is clearly brighter than the others?'
    @answer '3'
    @answer '4'
    @answer 'More than 4'
    @answer "Can't tell"
  
  @question 'Do the clumps appear in a straight line, a chain, or a cluster?', leadsTo: 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'Straight Line'
    @answer 'Chain'
    @answer 'Cluster'
    @answer 'Spiral'
  
  @question 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'Yes', leadsTo: 'Is the brightest clump central to the galaxy?'
    @answer 'No', leadsTo: 'Does the galaxy appear symmetrical?'
  
  @question 'Is the brightest clump central to the galaxy?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy appear symmetrical?'
    @answer 'No', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?'
  
  @question 'Does the galaxy appear symmetrical?', leadsTo: 'Do the clumps appear to be embedded within a larger object?', ->
    @answer 'Yes'
    @answer 'No'
  
  @question 'Do the clumps appear to be embedded within a larger object?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Yes'
    @answer 'No'
  
  @question 'Could this be a disk viewed edge-on?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its centre?'
    @answer 'No', leadsTo: 'Is there a sign of a bar feature through the centre of the galaxy?'
  
  @question 'Does the galaxy have a bulge at its centre?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Yes'
    @answer 'No'
  
  @question 'Is there a sign of a bar feature through the centre of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Bar'
    @answer 'No bar'
  
  @question 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?'
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?'
  
  @question 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @answer 'Tight'
    @answer 'Medium'
    @answer 'Loose'
  
  @question 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @answer '1'
    @answer '2'
    @answer '3'
    @answer '4'
    @answer 'More than 4'
    @answer "Can't tell"
  
  @question 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'No bulge'
    @answer 'Obvious'
    @answer 'Dominant'
  
  @question 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'Merging'
    @answer 'Tidal debris'
    @answer 'Both'
    @answer 'Neither'

module.exports = SloanTree
