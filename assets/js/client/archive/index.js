import Vue from 'vue'
import store from '../store'
import Index from './Index.vue'
import VModal from 'vue-js-modal'

Vue.use(VModal)
const initialElement = "#archive[data-behaviour='vue']"
window.startFileArchive = () => {
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
  window.startFileArchive()
})