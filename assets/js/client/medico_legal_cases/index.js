import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import VueTables from 'vue-tables-2'
import ToggleButton from 'vue-js-toggle-button'
import VueSweetalert2 from 'vue-sweetalert2'
import VModal from 'vue-js-modal'
 
Vue.use(ToggleButton)
Vue.use(VueTables.ServerTable)
Vue.use(VueSweetalert2)
Vue.use(VModal)

const initialElement = "#medico-legal-cases[data-behaviour='vue']"
window.startMedicoLegalCases = () => {
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
  window.startMedicoLegalCases()
})