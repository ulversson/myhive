import Swal from 'sweetalert2'

const setupHtmlRemoteDetailsLink = () => {
  $(document).off('click.remote-link')
    .on('click.remote-link', 'button[data-remote-details=true]', function(e){
      e.preventDefault()
      let requestUrl = $(this).data("url")
      let buttonMethod = $(this).data("method")
      let dataMethod = "GET"
      let dataTitle = $(this).data('modal-title')
      let modalClass = $(this).data('modal-class')
      if (buttonMethod) dataMethod = buttonMethod
  
      $.ajax({
        method: dataMethod,
        url: requestUrl
      }).done(function(htmlResponse) {
          $.showAlert({
            modalClass: `fade ${modalClass}`,
            modalDialogClass: "modal-lg",
            title: dataTitle,
            body: htmlResponse
          })
      })
    })
  }

  const setup = function() {
    $("[data-toggle=tooltip]").tooltip()
    $('select.select2').select2()
    $('p.alert').hide()
  }

  const csrfToken = function() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content")
  }

  const showAndFadeOutFlash = function(message, type) {
    if ($("p.alert").length === 0) {
      let flash = `<p class="alert alert-success" id='alert-info' role="alert" style='display: none'></p>`
      $('div.flash-container').html(flash)
    }
    $(`p#alert-${type}`).empty().show()
      .html(message).delay(4000).fadeOut(400)
  }

  const confirmDialog = function(callbackFn) {
    $(document).off('click.confirm').on('click.confirm', 
      'a.confirm-dialog', function(e){
        let deleteUrl = $(this).data("url")
        let title = $(this).data('title')
        let dataMethod = $(this).data('request-method')
        let text = $(this).data('text')
        let dataIcon = $(this).data('icon')
        let buttonColor = '#46be8a'
        let icon = `<i class="${dataIcon}"></i>&nbsp;`
        if (dataMethod === 'DELETE') {
          buttonColor = '#fb434a' 
        }
        e.preventDefault()
        Swal.fire({
          title: `${title}?`,
          text: text,
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: buttonColor,
          confirmButtonText: `${icon} YES`
        }).then((result) => {
          if (result.value) {
           $.ajax({
             type: dataMethod,
             data: {
               "_method": dataMethod,
               "_csrf_token" : csrfToken()
             },
             url: deleteUrl
           }).done((jsonResponse) => {
             if (jsonResponse.status === "ok") {
               showAndFadeOutFlash(jsonResponse.message, "info")
               if (callbackFn) {
                 callbackFn()
               } 
               $("div.modal").modal('hide')
             }
           }).fail(e => {
             Swal.fire({
               title: "Error",
               text: e.message             
              })
           })
          }
        })
    })
  }
  
export default {
  setupHtmlRemoteDetailsLink,
  confirmDialog,
  setup
}