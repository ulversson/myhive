import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'
import VueTables from 'vue-tables-2'
import ToggleButton from 'vue-js-toggle-button'
import VueSweetalert2 from 'vue-sweetalert2'
Vue.use(ToggleButton)
Vue.use(VueTables.ServerTable)
Vue.use(VueSweetalert2)

const initialElement = "#medico-legal-cases[data-behaviour='vue']"
window.startMedicoLegalCases = () => {
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