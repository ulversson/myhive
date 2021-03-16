
import Vue from 'vue'
import Index from './Index.vue'
import store from '../store'

const initialElement = "#literature[data-behaviour='vue']"
window.startLiterature = () => {
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