
const setupHtmlRemoteLink = () => {
  $(document).off('click.remote-link')
    .on('click.remote-link', 'button[data-remote=true]', function(e){
    e.preventDefault()
    let requestUrl = $(this).data("url")
    let buttonMethod = $(this).data("method")
    let dataMethod = "GET"
    if (buttonMethod) {
      dataMethod = buttonMethod
    }
    $.ajax({
      method: dataMethod,
      url: requestUrl
    }).done(function(htmlResponse) {
      $('body').on('shown.bs.modal', function(){
        $("[data-toggle=tooltip]").tooltip()
      })
      $.showModal({
        modalClass: "fade",
        modalDialogClass: "modal-lg",
        title: "User details", 
        body: htmlResponse
      })
    })
  })
}

export default {
  setupHtmlRemoteLink
}