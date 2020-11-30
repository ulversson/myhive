import Swal from 'sweetalert2'
import autosize from 'autosize'
import moment  from 'moment'
import Inputmask from 'inputmask'
import geolocator from 'geolocator'
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
    $('select.select2-tags').select2({
      tags: true, 
      multiple: true
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
     text, deleteUrl, callbackFn, cancelCallback = undefined, newContext) =>  {
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
            if (newContext) {
              callbackFn.call(newContext)
            } else {
              callbackFn()
            }
          }
          $("div.modal").modal('hide')
        }
      }).fail(e => {
        Swal.fire({
          icon: 'error',
          title: "Error",
          text: e.responseJSON.error.join(",")
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
      autoclose: true,
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
    $(fieldSelector).on('focusout', function(){
      $(fieldSelector).datetimepicker('hide')
    })
  }

  const autocompleteSearch = function(selector, multiple) {
    let searchUrl = $(selector).data('url')
    $(selector).select2({
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
          return queryParameters
        },
        processResults: function (data) {
          return {
            results: $.map(data.data, function (item) {
                return {
                    text: `${item.last_name} ${item.first_name}`,
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

  const getLocationCity = (ipAddress) => {
    geolocator.config({
      language: "en",
      google: {
        version: "3",
        key: "AIzaSyDFvxXPpBbDFbjnY4BKfhD1EijAZG8BMRU"
      }
    })

    window.onload = function () {
      var options = {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumWait: 1000,     
        maximumAge: 0,          
        desiredAccuracy: 100,    
        fallbackToIP: true,    
        addressLookup: true,   
        timezone: false,        
        staticMap: {
          size: '300x240'
        }       
      }
      geolocator.locate(options, function (err, location) {
        if (err) return console.log(err)
        updateLocation(location)
      })
    }
  }

const updateLocation = (location) => {
  if (location.address) {
    let style = 'maptype=roadmap&style=element:geometry%7Ccolor:0x1d2c4d&style=element:labels.text.fill%7Ccolor:0x8ec3b9&style=element:labels.text.stroke%7Ccolor:0x1a3646&style=feature:administrative.country%7Celement:geometry.stroke%7Ccolor:0x4b6878&style=feature:administrative.land_parcel%7Celement:labels.text.fill%7Ccolor:0x64779e&style=feature:administrative.province%7Celement:geometry.stroke%7Ccolor:0x4b6878&style=feature:landscape.man_made%7Celement:geometry.stroke%7Ccolor:0x334e87&style=feature:landscape.natural%7Celement:geometry%7Ccolor:0x023e58&style=feature:poi%7Celement:geometry%7Ccolor:0x283d6a&style=feature:poi%7Celement:labels.text.fill%7Ccolor:0x6f9ba5&style=feature:poi%7Celement:labels.text.stroke%7Ccolor:0x1d2c4d&style=feature:poi.park%7Celement:geometry.fill%7Ccolor:0x023e58&style=feature:poi.park%7Celement:labels.text.fill%7Ccolor:0x3C7680&style=feature:road%7Celement:geometry%7Ccolor:0x304a7d&style=feature:road%7Celement:labels.text.fill%7Ccolor:0x98a5be&style=feature:road%7Celement:labels.text.stroke%7Ccolor:0x1d2c4d&style=feature:road.highway%7Celement:geometry%7Ccolor:0x2c6675&style=feature:road.highway%7Celement:geometry.stroke%7Ccolor:0x255763&style=feature:road.highway%7Celement:labels.text.fill%7Ccolor:0xb0d5ce&style=feature:road.highway%7Celement:labels.text.stroke%7Ccolor:0x023e58&style=feature:transit%7Celement:labels.text.fill%7Ccolor:0x98a5be&style=feature:transit%7Celement:labels.text.stroke%7Ccolor:0x1d2c4d&style=feature:transit.line%7Celement:geometry.fill%7Ccolor:0x283d6a&style=feature:transit.station%7Celement:geometry%7Ccolor:0x3a4762&style=feature:water%7Celement:geometry%7Ccolor:0x0e1626&style=feature:water%7Celement:labels.text.fill%7Ccolor:0x4e6d70&size=300x481'
    let map = `https:${location.staticMap}&${style}`
    $("div.cui-login-block-sidebar").css('background-image', `url(${map})`)
    $("div.cui-login-block-sidebar").css('background-repeat', `no-repeat`)
    $("div.cui-login-block-sidebar").css('background-position', `center 66%`)
    $("div.cui-login-block-sidebar-place").html(`<i class="icmn-location mr-3"></i>&nbsp;${location.address.town}, ${location.address.city}`)
  }
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
  setup,
  getLocationCity
}
