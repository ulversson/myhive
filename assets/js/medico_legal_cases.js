import 'bootstrap4-toggle/js/bootstrap4-toggle.min.js'
import UI from './ui'
import formToObject from 'form_to_object'
const setupFormToggles = () => {
  $('#medico_legal_case_patient_deceased').change(function() {
    let isChecked = $(this).prop('checked')
    if (isChecked) {
      $("li#claimant-nav")
        .css('display', 'block')

    } else {
      $("li#claimant-nav")
        .css('display', 'none')
    }
  })
}

const nextTabShow = () => {
  $('a.next-tab').on('click', function(e){
      e.preventDefault()
      let nextTab = $('.nav-tabs .active').parent()
        .next('li').find('a')
      let tabVisible = $(nextTab).is(":visible")
      if (nextTab.length > 0 && tabVisible) {
        nextTab.trigger('click')
      } else if (nextTab.length > 0 && !tabVisible) {
        nextTab = nextTab.parent().next('li').find('a')
        nextTab.trigger('click')
      } else {
        $('.nav-tabs li:eq(0) a').trigger('click')
      }
  })
}

const getFormDatata = (formId) => {
  let form = document.querySelector(formId)
  return formToObject(form)
}

export default {
  getFormDatata,
  init() {
    UI.setup()
    setupFormToggles()
    nextTabShow()
    UI.attachDatePicker('.datepicker')
    UI.attachDatePicker('.datepicker2')
  }
}