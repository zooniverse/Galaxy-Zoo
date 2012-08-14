DecisionTree = require 'lib/decision_tree'

SloanTree = new DecisionTree 'sloan', ->
  @question 'Shape', 'Is the galaxy simply smooth and rounded, with no sign of a disk?', ->
    @answer 'Smooth', leadsTo: 'How rounded is it?', icon: 'smooth_round'
    @answer 'Features or disk', leadsTo: 'Could this be a disk viewed edge-on?', icon: 'feature'
    @answer 'Star or artifact', icon: 'star'
  
  @question 'Disk', 'Could this be a disk viewed edge-on?', ->
    @answer 'Yes', leadsTo: 'Does the galaxy have a bulge at its center? If so, what shape?', icon: 'yes'
    @answer 'No', leadsTo: 'Is there a sign of a bar feature through the center of the galaxy?', icon: 'no'
  
  @question 'Bar', 'Is there a sign of a bar feature through the center of the galaxy?', leadsTo: 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Bar', icon: 'yes'
    @answer 'No bar', icon: 'no'
  
  @question 'Spiral', 'Is there any sign of a spiral arm pattern?', ->
    @answer 'Spiral', leadsTo: 'How tightly wound do the spiral arms appear?', icon: 'yes'
    @answer 'No spiral', leadsTo: 'How prominent is the central bulge, compared with the rest of the galaxy?', icon: 'no'
  
  @question 'Bulge', 'How prominent is the central bulge, compared with the rest of the galaxy?', leadsTo: 'Is there anything odd?', ->
    @answer 'No bulge', icon: 'bulge_none'
    @answer 'Just noticeable', icon: 'bulge_noticeable'
    @answer 'Obvious', icon: 'bulge_obvious'
    @answer 'Dominant', icon: 'bulge_dominant'
  
  @question 'Odd', 'Is there anything odd?', ->
    @answer 'Yes', leadsTo: 'What are the odd features?', icon: 'yes'
    @answer 'No', icon: 'no'
  
  @question 'Odd', 'What are the odd features?', ->
    @answer 'Ring', icon: 'ring'
    @answer 'Lens or arc', icon: 'lens'
    @answer 'Disturbed', icon: 'disturbed'
    @answer 'Irregular', icon: 'irregular'
    @answer 'Other', icon: 'other'
    @answer 'Merger', icon: 'merger'
    @answer 'Dust lane', icon: 'dustlane'
  
  @question 'Round', 'How rounded is it?', leadsTo: 'Is there anything odd?', ->
    @answer 'Completely round', icon: 'smooth_round'
    @answer 'In between', icon: 'smooth_in-between'
    @answer 'Cigar shaped', icon: 'smooth_cigar'
  
  @question 'Bulge', 'Does the galaxy have a bulge at its center? If so, what shape?', leadsTo: 'Is there anything odd?', ->
    @answer 'Rounded', icon: 'edge_round'
    @answer 'Boxy', icon: 'edge_boxy'
    @answer 'No bulge', icon: 'no'
  
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

module.exports = SloanTree
