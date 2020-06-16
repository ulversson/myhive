import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import VueChatScroll from 'vue-chat-scroll'
import AudioVisual from 'vue-audio-visual'

Vue.use(VueChatScroll)
Vue.use(AudioVisual)
const initialElement = "#chat[data-behaviour='vue']"
window.startChat = () => {
  $.ajaxSetup({
    beforeSend: (request) => { 
      request
        .setRequestHeader("Authorization", 
          `Bearer ${window.localStorage.getItem('jwt')}`) 
    }
  })
  if(document.querySelector(initialElement)){
    new Vue({
      el: initialElement,
      store: store, 
      render: h => h(Index)
    })
  }
}