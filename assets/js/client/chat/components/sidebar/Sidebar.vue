<template>
  <div class="cui-utils-card-sidebar">
    <div class="cui-apps-messaging-header">
      <input class="form-control cui-apps-messaging-header-input" 
        placeholder="Search..." v-model="userFilter">
        <i class="icmn-search"></i>
      <button></button>
    </div>
    <UserList :users.sync="filteredUsers"/>
  </div>
</template>
<script>
import UserList from './UserList.vue'
export default {
  created() {
    this.loadChatUsers()
  },
  data() {
    return {
      users: [],
      userFilter: ''
    }
  },
  components: {
    UserList
  }, 
  computed: {
    filteredUsers() {
      return this.users.filter(user => {
        return user.first_name.toLowerCase().match(this.userFilter.toLowerCase()) 
          || user.last_name.toLowerCase().match(this.userFilter.toLowerCase())
      })
    }
  },
  methods: {
    loadChatUsers() {
      $.getJSON(`/api/v1/users`, (res) => {
        this.users = res.data
      })
    }
  }
}
</script>