
import Swal from 'sweetalert2'
const saveCVFields = (reload = true) => {
  let formData = $("form#cv-form").serialize() +`&_csrf_token=${UI.csrfToken()}`
  $.ajax({
    type: "PATCH",
    url: '/users/cv',
    data: formData
  }).done(() => {
    if (reload) window.location.reload()
  })
}

const onSaveCVFieldsClick = () => {
  $("button#save-cv-fields").on('click', function(){
    saveCVFields()
  })
}

const onDownloadCVasPDF = () => {
  $('a#cv-pdf-download').on('click', function(){
    let userId = $(this).data('id')
    Swal.fire({
      title: 'Would you like to save before downloading',
      text: "The current fields values will be in downloaded CV",
      icon: 'question',
      showCancelButton: true,
      cancelButtonText: 'No',
      confirmButtonText: 'Yes'
    }).then((result) => {
      if (result.value) {
        saveCVFields(false)
        cvDownload('pdf', userId)
      } else {
        console.log(result.value)
        cvDownload('pdf', userId)
      }
    })
  })
}

const cvDownload = (format, userId) => {
  window.location.href = `/user/cv/${format}/${userId}`
}

export default {
  init() {
    onSaveCVFieldsClick()
    onDownloadCVasPDF()
  }
}