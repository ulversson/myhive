import 'bootstrap4-toggle/js/bootstrap4-toggle.min.js'
import UI from './ui'
import Swal from 'sweetalert2'

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
  $('#medico_legal_case_patient_new').change(function() {
    let isChecked = $(this).prop('checked')
    let partialUrl = '/people/partial/new'
    
    if (isChecked) {
      clearErorrs()
      partialUrl = '/people/partial/new'
    } else {
      clearErorrs()
      partialUrl = '/people/partial/existing'
    }
    $.get(partialUrl, function(htmlResponse){
      let formContent = $($.parseHTML(htmlResponse)).find('form').html()
      $('div#patient-partial').html(formContent)
      UI.autocompleteSearch('select#medico_legal_case_patient_id', false)
      UI.setupBritishPhoneMask('medico_legal_case_patient_addresses_0_phone_number')
    })
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

const processErrors = (responseJson) => {
  let errors = {
    summary: {
      count: 0,
      fields: []
    }
  }
  for (let [key, value] of Object.entries(responseJson)) {
    if (Array.isArray(value)) {
      errors.summary.count = errors.summary.count + 1
      errors.summary.fields.push({
        field: key,
        errors: value
      })
    }
    else {
      if (errors[key] === undefined) errors[key] = {}
      if (errors[key]["fields"] === undefined) errors[key]["fields"] = []
      errors[key]["count"] =  Object.keys(value).length
      Object.keys(value).forEach((insideKey) => {
        errors[key]["fields"].push({
          field: insideKey,
          errors: value[insideKey]
        })
      })
    }
  }
  return errors
}
const clearErorrs = function() {
  $('span.badge-error').html('')
  $('.has-danger').removeClass('has-danger')
  $('span.help-block.text-danger').remove()
}

const renderJsonErrors = function(errors) {
  let fieldWithError, selector = null
  for (let [key, value] of Object.entries(errors)) {
    $(`span#badge-${key}`).html(value.count)
    value.fields.forEach((field) => {
      if (key === 'summary') {
        selector = `input#medico_legal_case_${field.field}, select#medico_legal_case_${field.field}`
        fieldWithError = $(selector)
        fieldWithError.addClass('has-error')
        fieldWithError.parents('div.form-group').addClass('has-danger')
        $(fieldWithError).next(".select2-container")
          .children('span.selection')
          .children('span')
          .addClass('has-danger')
        let errorHtml = `<span class='help-block text-danger'>${field.errors.join(',')}</span>`
        $(fieldWithError).after(errorHtml)
      }
      else {
        $(fieldWithError).next(".select2-container")
          .children('span.selection')
          .children('span')
          .addClass('has-danger')
        selector = `input#medico_legal_case_${key}_${field.field}`
        fieldWithError = $(selector)
        fieldWithError.addClass('has-danger')
        fieldWithError.parents('div.form-group').addClass('has-danger')
        let errorHtml = `<span class='help-block text-danger'>${field.errors.join(',')}</span>`
        $(fieldWithError).after(errorHtml)
      }
    })
  }
}

const onMedicoLegalFormSubmit = function() {
  $('button#save-new-mlc').on('click', function(e){
    clearErorrs()
    e.preventDefault()
    let form = "form#medico-legal-case-form"
    let formData = $(form).serialize()
    let saveUrl = $(form).attr('action')
    let instructedBy = $('#medico_legal_case_instructed_by').prop('checked') ? "claimant" : "defendant"
    $.ajax({
      type: "POST",
      url: saveUrl,
      data: formData + `&medico_legal_case[instructed_by]=${instructedBy}`
    }).done(function(resp) {
      window.location.href = resp
    }).catch(function(err) {
      clearErorrs()
      if (err.status === 422) {
        let responseJson = JSON.parse(err.responseText)
        let errors = processErrors(responseJson)
        renderJsonErrors(errors)
      } else {
        Swal.fire("Error", 
          "The server responded with error", 
        'error')
      }
    })
  })
}

export default {
  init() {
    UI.setup()
    setupFormToggles()
    nextTabShow()
    UI.attachDatePicker('.datepicker')
    UI.attachDatePicker('.datepicker2')
    UI.autocompleteSearch('select#medico_legal_case_user_ids', true)
    onMedicoLegalFormSubmit()
    UI.setupBritishPhoneMask('medico_legal_case_patient_addresses_0_phone_number')
    UI.setupBritishPhoneMask('medico_legal_case_claimant_addresses_0_phone_number')
    UI.setupBritishPhoneMask('medico_legal_case_instructing_party_addresses_0_phone_number')

  }
}



