Spine = require 'spine'

class Annotation extends Spine.Model
  @configure 'Annotation', 'key', 'value'

module.exports = Annotation
