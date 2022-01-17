 
import Swal from 'sweetalert2'
import UI from './ui'

const authenticate = (token, email) => {
  $(document).off('click.shar-auth').
    on('click.shar-auth', "a#shareable-authenticate", function(){
      $("div.loader.loader-double").addClass('is-active')
      $.ajax({
        url: `/shared/auth/${token}`, 
        type: "POST",
        headers: {'x-csrf-token': UI.csrfToken()},
        data: {
          "email": email, 
          "token": token,
          "authorization": {
            first_name: $("input#authorization_first_name").val().trim(),
            last_name: $("input#authorization_last_name").val().trim(),
            email: $("input#authorization_email").val().trim(),
            token: token, 
            email: email
          }
        }
      }).done((resp) => {
        $("div.loader.loader-double").removeClass('is-active')
        window.location.reload(true)
      }).fail((e) => {
        $("div.loader.loader-double").removeClass('is-active')
        Swal.fire("Error", 
          "Unable to authorize, please check fields are correct and try again", 
          "error"
        )
      })
  })
}

export default {
  authenticate
}