DecisionTree = require 'lib/decision_tree'

SloanTree = new DecisionTree 'sloan', ->
  @question 'q0', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @answer 'a0', 'Smooth', leadsTo: 'How rounded is it?'
    @answer 'a1', 'Features or disk', leadsTo: 'Does the galaxy have a mostly clumpy appearance?'
    @answer 'a2', 'Star or artifact'
  
  @question 'q1', 'How rounded is it?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'a0', 'Completely round'
    @answer 'a1', 'In between'
    @answer 'a2', 'Cigar shaped'
  
  @question 'q2', 'Does the galaxy have a mostly clumpy appearance?', ->
    @answer 'a0', 'Yes', leadsTo: 'How many clumps are there?'
    @answer 'a1', 'No', leadsTo: 'Could this be a disk viewed edge-on?'
  
  @question 'q3', 'How many clumps are there?', leadsTo: 'Do the clumps appear in a straight line, a chain, or a cluster?', ->
    @answer 'a0', '1', leadsTo: 'Does the galaxy appear symmetrical?'
    @answer 'a1', '2', leadsTo: 'Is there one clump which is clearly brighter than the others?'
    @answer 'a2', '3'
    @answer 'a3', '4'
    @answer 'a4', 'More than 4'
    @answer 'a5', "Can't tell"
  
  @question 'q4', 'Do the clumps appear in a straight line, a chain, or a cluster?', leadsTo: 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'a0', 'Straight Line'
    @answer 'a1', 'Chain'
    @answer 'a2', 'Cluster'
    @answer 'a3', 'Spiral'
  
  @question 'q5', 'Is there one clump which is clearly brighter than the others?', ->
    @answer 'a0', 'Yes', leadsTo: 'Is the brightest clump central to the galaxy?'
    @answer 'a1', 'No', leadsTo: 'Does the galaxy appear symmetrical?'
  
  @question 'q6', 'Is the brightest clump central to the galaxy?', ->
    @answer 'a0', 'Yes', leadsTo: 'Does the galaxy appear symmetrical?'
    @answer 'a1', 'No', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?'
  
  @question 'q7', 'Does the galaxy appear symmetrical?', leadsTo: 'Do the clumps appear to be embedded within a larger object?', ->
    @answer 'a0', 'Yes'
    @answer 'a1', 'No'
  
  @question 'q8', 'Do the clumps appear to be embedded within a larger object?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'a0', 'Yes'
    @answer 'a1', 'No'
  
  @question 'q9', 'Could this be a disk viewed edge-on?', ->
    @answer 'a0', 'Yes', leadsTo: 'Does the galaxy have a bulge at its centre?'
    @answer 'a1', 'No', leadsTo: 'Is there a sign of a bar feature through the centre of the galaxy?'
  
  @question 'q10', 'Does the galaxy have a bulge at its centre?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'a0', 'Yes'
    @answer 'a1', 'No'
  
  @question 'q11', 'Is there a sign of a bar feature through the centre of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @answer 'a0', 'Bar'
    @answer 'a1', 'No bar'
  
  @question 'q12', 'Is there any sign of a spiral arm pattern?', ->
    @answer 'a0', 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?'
    @answer 'a1', 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?'
  
  @question 'q13', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @answer 'a0', 'Tight'
    @answer 'a1', 'Medium'
    @answer 'a2', 'Loose'
  
  @question 'q14', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @answer 'a0', '1'
    @answer 'a1', '2'
    @answer 'a2', '3'
    @answer 'a3', '4'
    @answer 'a4', 'More than 4'
    @answer 'a5', "Can't tell"
  
  @question 'q15', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'a0', 'No bulge'
    @answer 'a1', 'Obvious'
    @answer 'a2', 'Dominant'
  
  @question 'q16', 'Is the galaxy currently merging or is there any sign of tidal debris?', ->
    @answer 'a0', 'Merging'
    @answer 'a1', 'Tidal debris'
    @answer 'a2', 'Both'
    @answer 'a3', 'Neither'

module.exports = SloanTree
