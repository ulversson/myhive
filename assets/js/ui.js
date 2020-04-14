
const setupHtmlRemoteDetailsLink = () => {
  $(document).off('click.remote-link')
    .on('click.remote-link', 'button[data-remote-details=true]', function(e){
      e.preventDefault()
      let requestUrl = $(this).data("url")
      let buttonMethod = $(this).data("method")
      let dataMethod = "GET"
      let dataTitle = $(this).data('modal-title')
      if (buttonMethod) {
        dataMethod = buttonMethod
      }
      $.ajax({
        method: dataMethod,
        url: requestUrl
      }).done(function(htmlResponse) {
        console.log(htmlResponse)
          setupModalsUI()
          $.showAlert({
            modalClass: "fade",
            modalDialogClass: "modal-lg",
            title: dataTitle,
            body: htmlResponse
          })
      })
    })
  }
  
  const setupModalsUI = function() {
    $('body').on('shown.bs.modal', function(){
      $("[data-toggle=tooltip]").tooltip()
      $('select.select2').select2()
    })
  }
  
export default {
  setupHtmlRemoteDetailsLink,
  setupModalsUI
}