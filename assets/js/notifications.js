import { Socket } from "phoenix"
import moment from 'moment'
import Swal from 'sweetalert2'
const notificationLoadURL = `/api/v1/notifications/unread`


const load = () => {
  onNotificationToggleChange()
  onClearNotifications()
  $.getJSON(notificationLoadURL, (jsonData) => {
    if (jsonData.count > 0) {
      $("div#notifications.cui-topbar-activity").html("")
      $("span#unread-count").html(jsonData.count)
      jsonData.data.forEach((notification, index) => {
        let notificationHtml = notificationTemplate(notification)
        $("div#notifications.cui-topbar-activity").append(notificationHtml)
      })
      getNotification()
      if ($('div.notification-item').length > 0) {
        $("div#notifications.cui-topbar-activity").append(clearHtml());
      }
    }
  })
  visitNotificationLink(function() {
    $('div.notification-detail-item').remove()
    Swal.fire({
      toast: true,
      title: "Access granted",
      position: 'top-right',
      text: 'Access to the shared files has been granted',
      type: 'success'
    })
  })
}  

const onNotificationToggleChange = () => {
   let selector = "input[name='settings\[notifications\]']"
   $(selector).on('change', function(){
    let isChecked = $(this).val()
    if (isChecked === 'true') {
      $(`input.notifications-radio:not(${selector})`)
      .removeAttr('disabled')
    } else {
      $(`input.notifications-radio:not(${selector})`)
        .attr('disabled', 'disabled')
    }
  })
}

const getSocketUrl = function() {
  let protocol = window.location.protocol == "https:" ? "wss://" : "ws://";
  if (protocol === "ws://") 
    return protocol + window.location.hostname + ":4000/socket"
  else if (protocol === "wss://" ) {
    return protocol + window.location.hostname + "/socket"
  }
}
const setupChannelForUser = (userId) => {
  const token = 'randomtoken'
  const socket = new Socket(getSocketUrl(), { 
      params: { token: token } 
  })

  socket.connect()
  let channel = socket
    .channel(`notifications:${userId}`, {}) 

  channel.join()
   .receive("ok",     
      resp => { console.log("Joined successfully", resp) })
   .receive("error", 
      resp => { console.log("Unable to join", resp) })


  channel.on('new_notification', payload => {
    if (payload.recipient_id === parseInt(userId)) {
      addNotification(payload)  
    }
    if ($('div.notification-item').length > 0) {
      $("div#notifications.cui-topbar-activity").append(clearHtml());
    }
  })
}

const clearHtml = () => {
  return `<div class='button clear-notifications' style=''>
      <a class='btn btn-xs btn-danger mt-1' style='margin: 0 auto;width: 150px;float: right;' id='clear-notifications'>
        <i class='fas fa-trash-alt'></i>
        &nbsp;Clear all notifications
      </a>
    </div>`;
}

const addNotification = (notification) => {
  $(".cui-topbar-item .alert").remove()
  let notificationHtml = notificationTemplate(notification)
  let currentCount = parseInt($("span#unread-count").text())

  $("div#notifications.cui-topbar-activity").prepend(notificationHtml)
  if (isNaN(currentCount)) currentCount = 0
  currentCount = currentCount+1
  $("span#unread-count").text(currentCount)
  if (notification.show_on_arrival) {
    $(`div.notification-item[data-id=${notification.id}]`).click()
  }
  getNotification()
}

const notificationTemplate = (notification) => {
  return `
    <div class="cui-topbar-activity-item notification-item" data-id='${notification.id}'>
      <i class="cui-topbar-activity-icon ${notification.icon}"></i>
        <div class="cui-topbar-activity-inner">
          <div class="cui-topbar-activity-title">
           <span class="pull-right">${moment(notification.inserted_at).fromNow()}</span>
            <a href="javascript: void(0);">${notification.topic}<span class="badge badge-danger">New</span></a>
          </div>
        <div class="cui-topbar-activity-descr">
          ${UI.unescapeHtml(notification.body)}
        </div>
        </div>
    </div>`
  }

  const getNotification = () => {
    $(document).off('click.not-item').on('click.not-item', "div.notification-item", function(){
      let notificationId = $(this).data('id')
      let currentCount = parseInt($("span#unread-count").text())
      $.get(`/notifications/${notificationId}`, (html) => {
        $("div#toast-notification-container").prepend(html)
        let newCount = currentCount - 1
        if (newCount < 0) newCOunt = 0
        if (newCount > 0) {
          $("span#unread-count").html(newCount);
        }
        else  {
          $("span#unread-count").html("")
          insertEmptyHtml()
          $("div.button.clear-notifications").remove()
        }
        $(`div.notification-detail-item[data-id='${notificationId}']`).toast('show')
        $(`div.cui-topbar-activity-item.notification-item[data-id=${notificationId}]`).remove()
      })
    })
  }
  const visitNotificationLink = (callback) => {
    $(document).off('click.not-link').on('click.not-link', 'a.notification-link', function() {
      let notificationUrl = $(this).data('url')
      $.get(notificationUrl).done((res) => {
        if (typeof callback === 'function') callback()
      })
    })
  }

  const visibleIds = () => {
    return $("div.notification-item").map((i,it) => $(it).data().id)
  }

  const insertEmptyHtml = () => {
    let emptyHtml = `<div class="alert alert-default">No new notifications</div>`
    $("div#notifications").html(emptyHtml);
    $("span#unread-count").html("")
  }

  const onClearNotifications = () => {
    $(document).off('click.clearnot').on('click.clearnot','div.button.clear-notifications a', function (){
      let ids = Array.from(visibleIds());
      $.ajax({
        type: "DELETE",
        url: '/api/v1/notifications/unread/all',
        data: {
          "ids" : ids.join(',')
        }
      }).done(() => {
        $("div.notification-item").remove()
        insertEmptyHtml()
      })
    })
  }

export default {
  setupChannelForUser,
  visitNotificationLink,
  load
}