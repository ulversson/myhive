import Vue from 'vue'
import Index from './PanelIndex.vue'
import store from '../store'

const initialElement = "#medico-legal-case-details[data-behaviour='vue']"
window.startPanelCaseDetails = () => {
  $.ajaxSetup({
    beforeSend: (request) => { 
      request
        .setRequestHeader("Authorization", 
          `Bearer ${window.localStorage.getItem('jwt')}`) 
    }
  })
  if(document.querySelector(initialElement)){
    var vm = new Vue({
      el: initialElement,
      store: store, 
      render: h => h(Index)
    })
    window.currentCase = vm
  }
}
