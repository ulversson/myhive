import Swal from 'sweetalert2'
import autosize from 'autosize'
import moment  from 'moment'
import Inputmask from 'inputmask'
window.moment = moment
require('tempusdominus-bootstrap-4')


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
    $('select.select2').select2({
      minimumResultsForSearch: -1
    })
    $('p.alert').hide()
    autosize(document.querySelectorAll('textarea'))
    goToTab()
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
        e.preventDefault()
        let deleteUrl = $(this).data("url")
        let title = $(this).data('title')
        let dataMethod = $(this).data('request-method')
        let text = $(this).data('text')
        let dataIcon = $(this).data('icon')
        runConfirmedAction(dataIcon, dataMethod, title, 
          text, deleteUrl, callbackFn)
    })
  }

const runConfirmedAction =(dataIcon, dataMethod, title,
     text, deleteUrl, callbackFn, cancelCallback) =>  {
  let buttonColor = '#46be8a'
  let icon = `<i class="${dataIcon}"></i>&nbsp;`
  if (dataMethod === 'DELETE') {
    buttonColor = '#fb434a'
  }
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
          "_csrf_token": csrfToken()
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
    } else {
      if (cancelCallback) {
        cancelCallback()
      }
    }
  })
  }

  const attachDatePicker = (fieldSelector) => {
    let dateValue = $(fieldSelector).val()
    if (dateValue) { 
      dateValue = moment(dateValue)
    } else {
      dateValue = ""
    }
    
    $(fieldSelector).datetimepicker({
      date: dateValue,
      icons: {
        time: 'fa fa-clock-o',
        date: 'fa fa-calendar',
        up: 'fa fa-arrow-up',
        down: 'fa fa-arrow-down',
        previous: 'fa fa-arrow-left',
        next: 'fa fa-arrow-right',
      },
      format: 'DD/MM/YYYY',
    })
  }

  const autocompleteSearch = function(selector, multiple) {
    let searchUrl = $(selector).data('url')
    $(selector).select2({
      tags: true,
      multiple: multiple,
      tokenSeparators: [',', ' '],
      minimumInputLength: 2,
      allowClear: true,
      minimumResultsForSearch: 10,
      ajax: {
        url: searchUrl,
        headers: { "Authorization": `Bearer ${window.localStorage.getItem('jwt')}` },
        dataType: "json",
        type: "GET",
        data: function (params) {
          var queryParameters = {
            q: params.term
          }
          return queryParameters;
        },
        processResults: function (data) {
          return {
            results: $.map(data.data, function (item) {
                return {
                    text: `${item.first_name} ${item.last_name}`,
                    id: item.id
                  }
                })
            }
        }
      }
    })
  }

  const setupBritishPhoneMask = function(selector) {
    let item = document.getElementById(selector)
    let im = new Inputmask("(+99)-9999-999-999")
    if (item === null) return
    im.mask(item)        
  }

  const goToTab = function() {
    let url = window.location.href
    if (url.indexOf("#") > 0){
    let activeTab = url.substring(url.indexOf("#") + 1)
      $('.nav[role="tablist"] a[href="#'+activeTab+'"]').tab('show')
    }
  
    $('a[role="tab"]').on("click", function() {
      let newUrl
      const hash = $(this).attr("href")
      if (hash.match('javascript')) return
      newUrl = url.split("#")[0] + hash
      history.replaceState(null, null, newUrl)
    })
  }

  const unescapeHtml = (string) => {
    return string
      .replace(/&amp;/g, "&")
      .replace(/&lt;/g, "<")
      .replace(/&gt;/g, ">")
      .replace(/&quot;/g, "\"")
      .replace(/&#039;/g, "'")
  }
  
export default {
  unescapeHtml,
  setupHtmlRemoteDetailsLink,
  confirmDialog,
  attachDatePicker,
  goToTab,
  csrfToken,
  runConfirmedAction,
  autocompleteSearch,
  setupBritishPhoneMask,
  showAndFadeOutFlash,
  setup
}
