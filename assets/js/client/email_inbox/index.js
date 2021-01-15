import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'

const initialElement = "#emails-inbox[data-behaviour='vue']"
window.startInbox = () => {
    $.ajaxSetup({
        beforeSend: (request) => {
            request
                .setRequestHeader("Authorization",
                    `Bearer ${window.localStorage.getItem('jwt')}`)
        }
    })
    if (document.querySelector(initialElement)) {
        var vm = new Vue({
            el: initialElement,
            store: store,
            render: h => h(Index)
        })
        window.inbox = vm
    }
}