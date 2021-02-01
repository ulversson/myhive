import Pickr from "@simonwep/pickr"
import Swal from "sweetalert2"
import UI from './ui'
import ReportSignature from './client/report_signature'
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

const hideOrShowButtonsFrom = (identity) => {
    if (identity === '#p-quick-links') {
      $('div.profile-buttons').removeAttr('style')
      $('div.profile-buttons').attr('style', 'display:none')
    } else {
      $('div.profile-buttons').removeAttr('style')
      $('div.profile-buttons').show('style', 'display: block')
    }
}

const onProfileTabChange = () => {
  $("div#profile-tabs li a ").on('click', function() {
    var identity = $(this).attr('href')
    hideOrShowButtonsFrom(identity)
  });
}

const currentTab = () => {
  return '#' + $("div#profile-tabs .tab-pane:visible").attr("id")
}

const withdrawAuthorization = () => {
  $('a#withdraw-auth').on('click', function() {
    let providerName = $(this).data('provider')
    $.ajax({
      type: 'DELETE',
      url: `/auth/${providerName}`,
      data: {
        _csrf_token: UI.csrfToken()
      }
    }).done(() => {
      window.location.reload(true)
    }).fail((err) => {
      Swal.fire(
        'Error',
        `Error withdrawing authorization for ${providerName}`, 
        'error'
      )
    })
  })
}

export default {
  currentTab,
  withdrawAuthorization,
  init(initialColor, editorContent) {
    initColorPicker('div.picker', initialColor)
    UI.setup()
    UI.confirmDialog(() => {
      window.location.reload(true)
    })
    $("button#profile-submit").on('click', () => {
      $("input#signature").val(window.quill.root.innerHTML)
      $("form#profile-form").submit()
    })
    onProfileTabChange()
    hideOrShowButtonsFrom(currentTab())
    withdrawAuthorization()
    ReportSignature.init()
    Editor.initWithExtraDropdownItems("#div_signature", {}, editorContent)
  }
}
