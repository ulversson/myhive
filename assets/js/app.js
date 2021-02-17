// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import css from "../app.scss"
import "phoenix_html"
import $ from 'jquery';
window.jQuery = $;
window.$ = $;
require('imports-loader?define=>false!datatables.net')(window, $)
require('imports-loader?define=>false!datatables.net-bs4')(window, $)
require('imports-loader?define=>false!datatables.net-responsive')(window, $)
import 'popper.js/dist/umd/popper'
import 'jquery-ui/ui/core'
import 'jquery-ui/ui/widgets/selectable'
import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/js/src/toast'
import 'perfect-scrollbar/src/index'
import 'bootstrap-select/dist/js/bootstrap-select'
import 'select2/dist/js/select2.full'
import 'bootstrap-show-modal/src/bootstrap-show-modal'
import 'pwstrength-bootstrap/dist/pwstrength-bootstrap'
import '@simonwep/pickr/dist/themes/nano.min.css'
import 'daterangepicker'
import '@fancyapps/fancybox'
import './cleanui/menu-left.cleanui'
import './cleanui/menu-top.cleanui'
import './cleanui/menu-right.cleanui'
import UI from './ui'
import Fn from './functions'
import './datatables'
import Mlc from './medico_legal_cases'
import PasswordStrength from './password-strength'
import Users from './users'
import Profile from './profile'
import Notifications from './notifications'
import Settings from './settings'
import Shareable from './shareable'
import Blog from './blog'
import Editor from './editor'
import EmailTemplate from './email_templates'
import ReportSignature from './client/report_signature'
import CV from './cv'
import UIError from './errors'
window.UIError = UIError
window.Users = Users
window.UI = UI
window.PasswordStrength = PasswordStrength
window.Mlc = Mlc
window.Profile = Profile
window.Notifications = Notifications
window.Settings = Settings
window.Shareable = Shareable
window.Fn = Fn
window.Blog = Blog
window.CV = CV
window.Editor = Editor
window.EmailTemplate = EmailTemplate
window.ReportSignature = ReportSignature
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import './client/medico_legal_cases'
import './client/medico_legal_cases/panelIndex'
import './client/file_manager'
import './client/chat'
import './client/time_sheet'
import './client/time_sheet/index.admin'
import './client/calendar'
import './client/archive'
import './client/shared_files'
import './client/shared_files/manager/index'
import './client/recycle_bin/index'
import './client/email_inbox/index'
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let userAttribute = document.querySelector("meta[name='user_id']")
let userId = null
if (userAttribute === null) {
    let items = window.location.pathname.split("/")
    userId = items[items.length - 1]
} else {
    userId = userAttribute.getAttribute('value')
}
let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Users.setupPhnoenixLiveHooks(),
    params: {
        _csrf_token: csrfToken,
        userId: userId
    }
})
liveSocket.connect()
Users.setupPresence(userId)

$(function() {
    Notifications.load(userId)
    Notifications.setupChannelForUser(userId)
    Settings.init()
    ReportSignature.uploadSignature()
     $(document).on('shown.bs.tab', function() {  
      ReportSignature.initCropping()
    })
})