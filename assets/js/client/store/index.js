import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    role: 'expert'
  },
  mutations: {
    setRole (state, role) {
      state.role = role
    }
  }
})
export default store