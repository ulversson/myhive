
const setupPasswordValidator = function(container) {
  "use strict"
  let options = {}
  options.ui = {
      container: 'form',
      viewports: {
        progress: ".pwstrength_viewport_progress"
    },
    showVerdictsInsideProgressBar: true
  }
    options.common = {
        onLoad() {
          $('#messages').text('Start typing password')
        }
    }
    $(container).pwstrength(options)
  }

  export default {
    init(container) {
      setupPasswordValidator(container)
    }
  }