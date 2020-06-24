import Vue from 'vue'
import Index from './IndexAdmin.vue'
import store from '../store'
import VueTables from 'vue-tables-2'
import ToggleButton from 'vue-js-toggle-button'

Vue.use(VueTables.ServerTable)
Vue.use(ToggleButton)

const initialElement = "#time-sheet-admin[data-behaviour='vue']"
window.startTimeSheetAdmin = () => {
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