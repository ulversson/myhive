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
import './cleanui/menu-left.cleanui'
import './cleanui/menu-top.cleanui'
import './cleanui/menu-right.cleanui'
import './cleanui/blog.cleanui'
import './cleanui/file-manager'
// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
