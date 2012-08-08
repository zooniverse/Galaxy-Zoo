DecisionTree = require 'lib/decision_tree'

SloanTree = new DecisionTree 'sloan', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @answer 'Smooth', leadsTo: 'How rounded is it?'
    @answer 'Features or disk', leadsTo: 'Could this be a disk viewed edge-on?'
    @answer 'Star or artifact'
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its center? If so, what shape?'
    @answer 'No', leadsTo: 'Is there a sign of a bar feature through the center of the galaxy?'
  
  @question 'Bar', 'Is there a sign of a bar feature through the center of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Bar'
    @answer 'No bar'
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?'
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?'
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is there anything odd?', ->
    @answer 'No bulge'
    @answer 'Just noticeable'
    @answer 'Obvious'
    @answer 'Dominant'
  
  @question 'Odd', 'Is there anything odd?', ->
    @answer 'Yes', leadsTo: 'What are the odd features?'
    @answer 'No'
  
  @question 'Odd', 'What are the odd features?', ->
    @answer 'Ring'
    @answer 'Lens or arc'
    @answer 'Disturbed'
    @answer 'Irregular'
    @answer 'Other'
    @answer 'Merger'
    @answer 'Dust lane'
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is there anything odd?', ->
    @answer 'Completely round'
    @answer 'In between'
    @answer 'Cigar shaped'
  
  @question 'Bulge', 'Does the galaxy have a bulge at its center? If so, what shape?', leadsTo: 'Is there anything odd?', ->
    @answer 'Rounded'
    @answer 'Boxy'
    @answer 'No bulge'
  
  @question 'Spiral', 'How tightly wound do the spiral arms appear?', leadsTo: 'How many spiral arms are there?', ->
    @answer 'Tight'
    @answer 'Medium'
    @answer 'Loose'
  
  @question 'Spiral', 'How many spiral arms are there?', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', ->
    @answer '1'
    @answer '2'
    @answer '3'
    @answer '4'
    @answer 'More than 4'
    @answer "Can't tell"

module.exports = SloanTree
