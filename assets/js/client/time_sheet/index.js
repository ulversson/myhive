import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import DatePicker from 'vue2-datepicker'
import VueTimepicker from 'vue2-timepicker'
import VueTheMask from 'vue-the-mask'

import 'vue2-datepicker/index.css'
import 'vue2-timepicker/dist/VueTimepicker.css'

Vue.use(DatePicker)
Vue.use(VueTheMask)
Vue.use(VueTimepicker)
const initialElement = "#time-sheet[data-behaviour='vue']"
window.startTimeSheet = () => {
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