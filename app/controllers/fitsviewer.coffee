FITS = require('fits')

class FITSViewer extends Spine.Controller
  
  constructor: ->
    @images = {}
  
  addImage: (obj) ->
    console.log 'addImage'
    @images[obj.band] = new FITS.File(obj.arraybuffer)
    console.log @images
  
module.exports = FITSViewer