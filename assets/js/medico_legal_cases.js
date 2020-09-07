import 'bootstrap4-toggle/js/bootstrap4-toggle.min.js'
import UI from './ui'
import Swal from 'sweetalert2'

const setupFormToggles = () => {
  let loadCheck = $('input[name="medico_legal_case[patient][deceased]"]:checked').val()
  
  toggleClaimant(loadCheck)
  $('input[name="medico_legal_case[patient][deceased]"]').click(function() {
    let checkedValue  =  $('input[name="medico_legal_case[patient][deceased]"]:checked').val()

    toggleClaimant(checkedValue)
  })
  
  $('input[name="medico_legal_case[new_or_existing]"]').click(function() {
    let checkedVal = $('input[name="medico_legal_case[new_or_existing]"]:checked').val()
    $.get(`/people/partial/${checkedVal}`, function(htmlResponse){
      let formContent = $($.parseHTML(htmlResponse)).find('form').html()
      $('div#patient-partial').html(formContent)
      UI.autocompleteSearch('select#medico_legal_case_patient_id', false)
      UI.setupBritishPhoneMask('medico_legal_case_patient_addresses_0_phone_number')
    })
  })
}

const toggleClaimant = (value) => {
  if (value === 'true') {
    $("li#claimant-nav")
      .css('display', 'block')

  } else {
    $("li#claimant-nav")
      .css('display', 'none')
  }
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

const prevTabShow = () => {
  $('a.prev-tab:first').hide()
  $('a.prev-tab').on('click', function(e){
    e.preventDefault()
    let prevTab = $('.nav-tabs .active').parent()
        .prev('li').find('a')
    let tabVisible = $(prevTab).is(":visible")
    if (prevTab.length > 0 && tabVisible) {
      prevTab.trigger('click')
    } else if (prevTab.length > 0 && !tabVisible) {
      prevTab = prevTab.parent().prev('li').find('a')
      prevTab.trigger('click')
    } else {
      $('.nav-tabs li:eq(0) a').trigger('click')
    }
  })
}

const emptyErrorObject = (errors, key) => {
  if (errors[key] === undefined) errors[key] = {}
  if (errors[key]["fields"] === undefined) errors[key]["fields"] = []
  if (errors[key]["count"] === undefined) errors[key]["count"] = 0
  return errors
}

const addErrorFromObject = (errors, obj, key) => {
  Object.keys(obj).forEach((insideKey) => {
    errors[key]["fields"].push({
      field: insideKey,
      errors: obj[insideKey]  
    })
    if (insideKey !== 'addresses') {
      errors[key].count = errors[key].count + 1  
    }
  })
}

const processAllResponseErrors = (responseJson) => {
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
    } else if (typeof value === "object" && value.addresses) {
      errors = emptyErrorObject(errors, key)
      addErrorFromObject(errors, value.addresses[0], key)
      addErrorFromObject(errors, value, key)
    } 
  }
  return errors
}
const clearPageErrors = function() {
  $('span.badge-error').html('')
  $('.has-danger').removeClass('has-danger')
  $('span.help-block.text-danger').remove()
}

const addSelect2Error = (field)  => {
  $(field).next(".select2-container")
    .children('span.selection')
    .children('span')
    .addClass('has-danger')
}

const addSummaryTabErrors = (field)  => {
  let selector = `input#medico_legal_case_${field.field}, select#medico_legal_case_${field.field}`
  let error = field.errors.join(',')
  appendSingleError(selector, error)
}

const addAddressFieldsErrors = (field, key) => {
  for (let [akey, _] of Object.entries(field.errors[0])) {
    let selector = `input#medico_legal_case_${key}_${field.field}_0_${akey}, textarea#medico_legal_case_${key}_${field.field}_0_${akey}`
    let errorText = field.errors[0][akey].join(",")
    appendSingleError(selector, errorText)
  }
}

const appendSingleError = (selector, errorText) => {
  let fieldWithError = $(selector)
  let errorHtml = `<span class='help-block text-danger'>${errorText}</span>`

  fieldWithError.addClass('has-danger')
  fieldWithError.parents('div.form-group').addClass('has-danger')
  $(fieldWithError).after(errorHtml)
}

const renderJsonErrors = function(errors) {
  for (let [key, value] of Object.entries(errors)) {
    $(`span#badge-${key}`).html(value.count)
    value.fields.forEach((errorField) => {
      if (key === 'summary') addSummaryTabErrors(errorField)
      else {
        addSelect2Error(errorField)
        if (errorField.field.match('addresses')) {
          addAddressFieldsErrors(errorField, key)
        } else {
          let selector = `input#medico_legal_case_${key}_${errorField.field}`
          let errorText = errorField.errors.join(',')
          appendSingleError(selector, errorText) 
        }
      }
    })
  }
}
const handleInvalidResponse = function(err) {
  clearPageErrors()
  if (err.status === 422) {
    let responseJson = JSON.parse(err.responseText)
    let errors = processAllResponseErrors(responseJson)
    renderJsonErrors(errors)
  }
  else {
    Swal.fire("Error", 
      "The server responded with error", 'error')
  }
}

const onMedicoLegalFormSaveSubmit = function() {
  $('button#save-new-mlc').on('click', function(e){
    clearPageErrors()
    e.preventDefault()
    let form = "form#medico-legal-case-form"
    let formData = $(form).serialize()
    let saveUrl = $(form).attr('action')
    let instructedBy = $('input[name="medico_legal_case[instructed_by]"]:checked').val()
    $.ajax({
      type: "POST",
      url: saveUrl,
      data: formData + `&medico_legal_case[instructed_by]=${instructedBy}`
    }).done(function(resp) {
      window.location.href = resp
    }).catch(function(err) {
      handleInvalidResponse(err)
    })
  })
}

const onMedicoLegalFormUpdateSubmit = function() {
  $('button#update-mlc').on('click', function(e){
    clearPageErrors()
    e.preventDefault()
    let form = "form#medico-legal-case-update-form"
    let formData = $(form).serialize()
    let saveUrl = $(form).attr('action')
    let instructedBy = $('input[name="medico_legal_case[instructed_by]"]:checked').val()
    $.ajax({
      type: "PUT",
      url: saveUrl,
      data: formData + `&medico_legal_case[instructed_by]=${instructedBy}`
    }).done(function(resp) {
      window.location.href = resp
    }).catch(function(err) {
      handleInvalidResponse(err)
    })
  })
}

const preloadUsersForEdit = function(ids) {
  $.getJSON(`/api/v1/users/for_select?ids=${ids}`, (jsonResponse) => {
    jsonResponse.forEach((element, index) => {
      let fullName = `${element.first_name} ${element.last_name}`
      let option = new Option(fullName, element.id, true, true)
      $('select#medico_legal_case_user_ids').append(option)
    })
  })
}

const backFromNewCase = () => {
  Swal.fire({
    title: 'Case not saved',
    text: "Are you sure you want to navigate away?",
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, leave'
  }).then((result) => {
    if (result.value) {
      window.history.go(-1)
    }
  })
}

export default {
  preloadUsersForEdit,
  backFromNewCase,
  init() {
    UI.setup()
    setupFormToggles()
    nextTabShow()
    prevTabShow()
    UI.attachDatePicker('.datepicker')
    UI.attachDatePicker('.datepicker2')
    UI.autocompleteSearch('select#medico_legal_case_user_ids', true)
    onMedicoLegalFormSaveSubmit()
    onMedicoLegalFormUpdateSubmit()
    UI.setupBritishPhoneMask('medico_legal_case_patient_addresses_0_phone_number')
    UI.setupBritishPhoneMask('medico_legal_case_claimant_addresses_0_phone_number')
    UI.setupBritishPhoneMask('medico_legal_case_instructing_party_addresses_0_phone_number')
  }
}