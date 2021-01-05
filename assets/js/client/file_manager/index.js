import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import VueSweetalert2 from 'vue-sweetalert2'
import VModal from 'vue-js-modal'
// @ts-ignore
import VuePlyr from 'vue-plyr'
import VueLazyLoad from 'vue-lazyload'
import { Datetime } from 'vue-datetime'
import KnobControl from 'vue-knob-control'
import vSelect from 'vue-select'
import Croppa from 'vue-croppa'
import 'vue-datetime/dist/vue-datetime.css'
import 'vue-select/dist/vue-select.css'
import 'vue-croppa/dist/vue-croppa.css'

Vue.use(VueLazyLoad)
Vue.use(VueSweetalert2)
Vue.use(Datetime)
Vue.use(VModal)
Vue.use(Croppa)
Vue.component('v-select', vSelect)
Vue.use(VuePlyr, {
    plyr: {
        fullscreen: { enabled: false },
        seekTime: 1
    },
})
Vue.use(KnobControl)

const initialElement = "#folders[data-behaviour='vue']"
window.startFileManager = () => {
    $.ajaxSetup({
        beforeSend: (request) => {
            request
                .setRequestHeader("Authorization",
                    `Bearer ${window.localStorage.getItem('jwt')}`)
        }
    })
    if (document.querySelector(initialElement)) {
        new Vue({
            el: initialElement,
            store: store,
            // @ts-ignore
            render: h => h(Index)
        })
    }
}