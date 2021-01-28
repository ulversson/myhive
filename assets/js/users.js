import Datatable from './datatables'
import UI from './ui'
import { Socket, Presence } from "phoenix"
import humanizeDuration from 'humanize-duration'
import Downloader from './ajax-downloader'
const loadUsersDataTable = () => {
    if (window.usersDT) window.usersDT.destroy()
    Datatable.initializeWithColumns('usersDT', 'table#users-datatable', [
        { "data": "id", "name": "id", "autoWidth": true, "sortable": true },
        { "data": "first_name", "name": "first_name", "autoWidth": true, "sortable": true },
        { "data": "last_name", "name": "last_name", "autoWidth": true, "sortable": true },
        {
            "data": "email",
            "name": "email",
            "autoWidth": true,
            "sortable": true,
            "render": function(data, type, object, meta) {
                return `<a href='mailto:${data}'>${data}</a>`
            }
        },
        {
            "data": "phone_number",
            "name": "Phone",
            "autoWidth": true,
            "sortable": false,
            "render": function(data, type, object, meta) {
                return `<a href='tel://${data}'>${data}</a>`
            }
        },
        {
            "data": "roles",
            "name": "roles",
            "autoWidth": true,
            "sortable": true,
            "render": function(data, type, object, meta) {
                if (data !== undefined) {
                    let stringData = ""
                    stringData = `<span class="badge badge-pill badge-secondary badge-lg font-size-14">${roleFromData(data)}</span>`
                    return stringData;
                }
            }
        },
        {
            "data": "roles",
            "name": "roles",
            "autoWidth": true,
            "sortable": false,
            "render": function(data, type, object, meta) {
                let buttons = `<button data-id='${object.id}' data-remote-details="true" data-modal-class='user-details' type="button" data-url="/users/${object.id}" data-modal-title="${object.first_name} ${object.last_name}'s details" class="btn btn-xs btn-outline-info rounded-circle" data-toggle='tooltip' data-title='User details and statistics'><i class='fa fa-eye'></i></button>`
                if (currentUserId() !== object.id) {
                    buttons += `&nbsp;<a href='javascript:void(0)' data-icon='fa fa-trash-alt' data-text='This action cannot be reverted' data-request-method='DELETE' data-url="/users/${object.id}" class="confirm-dialog btn btn-xs btn-outline-danger rounded-circle" data-toggle='tooltip' data-title='Remove user'><i class='icmn-bin2'></i></a>`
                }
                return buttons
            }
        }
    ])
}

const currentUserId = () => {
    return $("div#user-data").data().userId
}


const currentUserName = () => {
    return $("div#user-data").data().username
}


const setupPhnoenixLiveHooks = () => {
    let Hooks = {}

    Hooks.PhoneNumber = {
        mounted() {
            UI.setupBritishPhoneMask("user_phone_number")
        }
    }
    Hooks.UI = {
        page() { UI.setup() }
    }
    return Hooks
}

const storedOnlineUsers = () => {
    return JSON.parse(window.localStorage.getItem('onlineUsers'))
}

const roleFromData = (data) => {
    let string = data.join(",").replace(/_/g, ' ')
    return string.charAt(0).toUpperCase() + string.slice(1)
}

const userName = () => {

}

const onlineUsersIds = () => {
    let users = []

    window.presence.list((id, { metas: [first, ...rest] }) => {
        users.push({
            id: parseInt(id),
            online_at: parseInt(first.online_at)
        })
    })
    window.localStorage.setItem('onlineUsers', JSON.stringify(users))
    return users
}

const setupPresence = (userId) => {
    if (window.precence) return
    let socket = new Socket("/socket", {
        params: { user_id: userId }
    })

    let channel = socket.channel("room:lobby", {})
    let presence = new Presence(channel)
    presence.onSync(() => onlineUsersIds())

    socket.connect()
    channel.join()
    window.presence = presence
}

const onUserDetailsModalShow = () => {
    $(document).on('shown.bs.modal', 'div.user-details', function() {
        UI.setup()
        let currentPopupId = $('span#user-id:visible').data('user-id')
        let popupUserOnline = Users.onlineUsersIds().filter((i) => { return i.id == currentPopupId })[0]
        if (popupUserOnline && popupUserOnline.id == currentPopupId) {
            console.log(popupUserOnline)
            setDetailsPopupOnline(currentPopupId, popupUserOnline.online_at)
        }
    })
}

const setDetailsPopupOnline = (userId, online_at) => {
    $(`span#online-status[data-user-id='${userId}']`)
        .removeClass('red')
        .addClass('green')
        .contents().filter((_, el) => el.nodeType === 3)
        .remove()
    $('i.status-text:visible').after('&nbsp;online')
    let time = parseInt(new Date(online_at * 1000).getTime() - parseInt(new Date().getTime())).toFixed()
    let onlineSince = humanizeDuration(time, { round: true })
    $("small#online-since").text(`for: ${onlineSince}`)
}

const processCVBundle = () => {
    $('button#cv-bundle-generate').on('click', () => {
        let originalHtml = `(Re)generate CV bundle&nbsp;<i class="fa fa-redo-alt"></i>`
        let processingHtml = `
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        Processing all CVs. please wait...`
        let downloadBundleHtml = `<button class="btn btn-info active" type="button" data-toggle='tooltip'
      onclick="javascript:window.location.href='/cv_bundle/download'"
      data-title='Download last bundle' id='cv-bundle-download'>
      Download last&nbsp;
      <i class="icmn-download2"></i>
      </button>`
        $('button#cv-bundle-generate').html(processingHtml)
        Downloader.downloadWithCallback(`/cv_bundle`, {
            _csrf_token: UI.csrfToken()
        }, {
            contentType: "application/zip",
            fileName: "CV bundle.zip"
        }, () => {
            $("button#cv-bundle-generate").html(originalHtml)
            $('span.download-bundle').html(downloadBundleHtml)
        })
    })
}

export default {
    loadUsersDataTable,
    setupPhnoenixLiveHooks,
    onlineUsersIds,
    storedOnlineUsers,
    currentUserId,
    currentUserName,
    setupPresence,
    init() {
        onUserDetailsModalShow()
        loadUsersDataTable()
        UI.setup()
        UI.confirmDialog(() => {
            window["usersDT"].ajax.reload()
        })
        processCVBundle()
    }
}