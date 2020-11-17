import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import VueSweetalert2 from 'vue-sweetalert2'
import VModal from 'vue-js-modal'
import VuePlyr from 'vue-plyr'
import VueLazyLoad from 'vue-lazyload'
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(VueLazyLoad)
Vue.use(VueSweetalert2)
Vue.use(Datetime)
Vue.use(VModal)
Vue.use(VuePlyr, {
  plyr: {
    fullscreen: { enabled: false },
    seekTime: 1
  },
})

const initialElement = "#folders[data-behaviour='vue']"
window.startFileManager = () => {
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
