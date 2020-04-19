import Vue from 'vue'
import Index from './Index.vue'
const initialElement = "#medico-legal-cases[data-behaviour='vue']"

window.startMedicoLegalCases = () => {
  if(document.querySelector(initialElement)){
    new Vue({
      el: initialElement,
      render: h => h(Index)
    })
  }
}
$(function(){
  window.startMedicoLegalCases()
})