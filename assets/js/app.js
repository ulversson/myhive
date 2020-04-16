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
require('imports-loader?define=>false!datatables.net-bs4' )( window, $ );
require('imports-loader?define=>false!datatables.net-responsive')(window, $)
import 'popper.js/dist/umd/popper'
import 'jquery-ui/ui/core'
import 'jquery-ui/ui/widgets/selectable'
import 'bootstrap/dist/js/bootstrap'
import 'jquery-mousewheel/jquery.mousewheel'
import 'perfect-scrollbar/src/index'
import 'spin.js/spin'
import 'ladda/js/ladda'
import 'bootstrap-select/dist/js/bootstrap-select'
import 'select2/dist/js/select2.full'
import 'summernote/dist/summernote'
import 'dropify/dist/js/dropify'
import 'bootstrap-show-modal/src/bootstrap-show-modal'
import 'pwstrength-bootstrap/dist/pwstrength-bootstrap'
import './cleanui/menu-left.cleanui'
import './cleanui/menu-top.cleanui'
import './cleanui/menu-right.cleanui'
import './cleanui/blog.cleanui'
import './cleanui/file-manager'
import UI from './ui'
import './datatables'
import PasswordStrength from './password-strength'
import Users from './users'
window.Users = Users
window.UI = UI
window.PasswordStrength = PasswordStrength
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let userId = document.querySelector("meta[name='user_id']").getAttribute('value')
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Users.setupPhnoenixLiveHooks(), 
  params: {
    _csrf_token: csrfToken,
    userId: userId
  }
})
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
