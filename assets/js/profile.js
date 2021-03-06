import Pickr from "@simonwep/pickr"
import UI from './ui'
const initColorPicker = function(el, initialColor) {
  window.pickr = Pickr.create({
    el: el,
    theme: "nano", // or 'monolith', or 'nano'
    default: '#bdc6cc',
    swatches: [
      "rgba(244, 67, 54, 1)",
      "rgba(233, 30, 99, 0.95)",
      "rgba(156, 39, 176, 0.9)",
      "rgba(103, 58, 183, 0.85)",
      "rgba(63, 81, 181, 0.8)",
      "rgba(33, 150, 243, 0.75)",
      "rgba(3, 169, 244, 0.7)",
      "rgba(0, 188, 212, 0.7)",
      "rgba(0, 150, 136, 0.75)",
      "rgba(76, 175, 80, 0.8)",
      "rgba(139, 195, 74, 0.85)",
      "rgba(205, 220, 57, 0.9)",
      "rgba(255, 235, 59, 0.95)",
      "rgba(255, 193, 7, 1)",
    ],
    components: {
      preview: true,
      opacity: false,
      hue: true,
      interaction: {
        hex: false,
        rgba: false,
        hsla: false,
        hsva: false,
        cmyk: false,
        input: true,
        clear: false,
        save: true,
      },
    },
  })
  bindPickerEvents(initialColor)
}

const bindPickerEvents = function(initialColor) {
  window.pickr.on('init', instance => {
    instance.setColor(initialColor)
    $("input#settings_default_color").val(initialColor)
  }).on('save', (color, instance) => {
    console.log('save', color, instance)
    let selectedColor = color.toRGBA().toString()
    $("input#settings_default_color").val(selectedColor)
    window.pickr.hide()
  })
}

export default {
  init(initialColor) {
    initColorPicker('div.picker', initialColor)
    UI.setup()
    UI.confirmDialog(() => {
      window.location.reload(true)
    })
    $("button#profile-submit").on('click', () => {
      $("form#profile-form").submit()
    })
  }
}
