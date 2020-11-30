
const clearErorrs = () => {
  $(".is-invalid").removeClass('is-invalid')
  $('span.invalid-feedback').html('')
}

const renderJsonErrors = (errors, fieldPrefix) => {
  for (let [key, value] of Object.entries(errors)) {
    let span = `span#${fieldPrefix}_${key}`
    let errorString  = value.join(',')
    $(span).prev().addClass('is-invalid')
    $(span).html(errorString)
  }
}

const errorResponse = (err, fieldPrefix) => {
  clearErorrs()
  if (err.status === 422) {
    let responseJson = JSON.parse(err.responseText)
    renderJsonErrors(responseJson.errors, fieldPrefix)
  }
  else {
    Swal.fire("Error", "The server responded with error", 'error')
  }
}

export default {
  clearErorrs, renderJsonErrors, errorResponse
}