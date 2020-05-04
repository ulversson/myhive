import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    role: 'expert',
    caseFolder: window.localStorage.getItem('caseFolder'),
    folderId: window.localStorage.getItem('currentFolder'),
    order: 'asc',
    column: 'name',
    selectedItems: [],
    csrfToken: document.querySelector("meta[name='csrf-token']").getAttribute("content")
  },
  mutations: {
    setRole (state, role) {
      state.role = role
    },
    setOrder(state, order) {
      state.order = order
    },
    setColumn(state, column) {
      state.column = column
    },
    removeSelectedItem(state, data) {
      let element = state.selectedItems.find(i => i.id === data.id && i.type === data.type)
      let idx = state.selectedItems.indexOf(element)
      state.selectedItems.splice(idx, 1)
    },
    addSelectedItem(state, data) {
      state.selectedItems.push(data)
    }
   },
   actions: {
     setCaseFolder ({commit}, payload) {
      let folderId = payload.caseFolder
      window.localStorage.setItem('caseFolder', folderId)
      return $.getJSON(`/api/v1/folders/${folderId}?order=${store.state.order}&column=${store.state.column}`)
     },
     setCurrentFolder (state, payload) {
      let folderId = payload.currentFolder
      window.localStorage.setItem('currentFolder', folderId)
      return $.getJSON(`/api/v1/folders/${folderId}?order=${store.state.order}&column=${store.state.column}`)
    }
   }
})
export default store