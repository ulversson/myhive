var svg2img = require('svg2img')
export default {
  svgToPng(svgString) {
    svg2img(svgString, function(error, buffer) {
     buffer.toString('base64')
    })
  }
}