import Vue from 'vue'
import store from '../store'
import Index from './Index.vue'
import VModal from 'vue-js-modal'
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(VModal)
Vue.use(Datetime)
const initialElement = "#calendar[data-behaviour='vue']"
window.startCalendar = () => {
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
$(function(){
  window.startCalendar()
})