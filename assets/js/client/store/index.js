import Vue from 'vue'
import Vuex from 'vuex'
import $ from 'jquery'
Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    role: 'expert',
    caseFolder: window.localStorage.getItem('caseFolder'),
    folderId: window.localStorage.getItem('currentFolder'),
    order: 'asc',
    conversation: {
      title: "myHive Lobby", 
      slug: 'myhive-lobby',
      private: false
    },
    appModules: [],
    column: 'name',
    peerConnection: null,
    localStream: new MediaStream(),
    currentMedicoLegalCaseId: localStorage.getItem('currentMedicoLegalCaseId'),
    currentAccount: localStorage.getItem('currentAccount'),
    selectedItems: [],
    settings: {},
    videoChannel: null,
    callOffer: null,
    isVideoCall: false,
    mainAvatar: "",
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
    },
    setSettings(state, settings) {
      state.settings = settings.settings
    },
    setMedicoLegalCaseId(state, medicoLegalCaseId) {
      state.currentMedicoLegalCaseId = medicoLegalCaseId
    },
    setAccountId(state, accountId) {
      state.currentAccount = accountId
    },
    setAppModules(state, modules) {
      state.appModules = modules
    },
    setConversation(state, conversation) {
      state.conversation = conversation
      this._vm.$swal({
        toast: true,
        timer: 2000,
        icon: 'info',
        position: 'top-right',
        showConfirmButton: false, 
        title: `Connected with chat room: ${conversation.title}`
      })
    },
    setLocalStream(state, stream) {
      state.localStream = stream
    },
    setPeerConn(state, conn) {
      state.peerConnection = conn
    },
    setVideoChannel(state, channel) {
      state.videoChannel = channel
    },
    setVideoCall(state, isCall) {
      state.isVideoCall = isCall
    },
    setMainAvatar(state, avatar){
      state.mainAvatar = avatar
    },
    setCallOffer(state, offer){
      state.callOffer = offer
    }
   },
   actions: {
     setCaseFolder ({commit}, payload) {
        let folderId = payload.caseFolder
        window.localStorage.setItem('caseFolder', folderId)
        return $.getJSON(`/api/v1/folders/${folderId}?order=asc&column=name`)
     },
     setCurrentFolder (state, payload) {
        let folderId = payload.currentFolder
        window.localStorage.setItem('currentFolder', folderId)
        return $.getJSON(`/api/v1/folders/${folderId}?order=asc&column=name`)
     },
     loadAppModules (state, accountId) {
       return $.getJSON(`/api/v1/modules/${accountId}`) 
     }
  }
})
export default store