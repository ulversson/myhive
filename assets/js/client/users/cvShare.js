
import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'

const initialElement = "#cv-share[data-behaviour='vue']"
window.startCVShare = () => {
  $.ajaxSetup({
    beforeSend: (request) => { 
      request
        .setRequestHeader("Authorization", 
          `Bearer ${window.localStorage.getItem('jwt')}`) 
    }
  })
  if(document.querySelector(initialElement)){
    window.cvShareApp = new Vue({
      el: initialElement,
      store: store, 
      render: h => h(Index)
    })
  }
}