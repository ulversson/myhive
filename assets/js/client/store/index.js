import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    role: 'expert',
    caseFolder: window.localStorage.getItem('caseFolder'),
    folderId: window.localStorage.getItem('currentFolder')
  },
  mutations: {
    setRole (state, role) {
      state.role = role
    }
   },
   actions: {
     setCaseFolder ({commit}, payload) {
      let folderId = payload.caseFolder
      window.localStorage.setItem('caseFolder', folderId)
      return $.getJSON(`/api/v1/folders/${folderId}`)
     },
     setCurrentFolder (state, payload) {
      let folderId = payload.currentFolder
      window.localStorage.setItem('currentFolder', folderId)
      return $.getJSON(`/api/v1/folders/${folderId}`)
    }
   }
})
export default store