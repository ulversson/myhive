<template>
  <div class="cui-utils-card-sidebar">
    <div class="cui-apps-messaging-header">
      <input class="form-control cui-apps-messaging-header-input" 
        placeholder="Search..." 
        v-model="userFilter">
        <i class="icmn-search"></i>
      <button></button>
    </div>
    <UserList :users.sync="filteredUsers" ref="list"/>
  </div>
</template>
<script>
import UserList from './UserList.vue'
import conversation from '../../mixins/conversation'
export default {
  created() {
    this.loadChatUsers('myhive-lobby')
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
    orderedUsers: function() {
      return this.users.concat().sort((a, b) => {
        const aOnline  = this.onlineUsers.includes(a.id)
        const bOnline  = this.onlineUsers.includes(b.id)
        if (aOnline != bOnline) {
          if (aOnline) {
            return -1
          } else {
            return 1
          }
        }
        const aHasLastMessage = Object.keys(a.last_message).length !== 0
        const bHasLastMessage = Object.keys(b.last_message).length !== 0

        if (aHasLastMessage != bLastMessage) {
          if (aHasLastMessage) {
            return -1
          } else {
            return 1
          }
        }

        const aLastMessage = moment(a.last_message.inserted_at).toDate()
        const bLastMessage = moment(b.last_message.inserted_at).toDate()
        if (aLastMessage != bLastMessage) {
          if (aLastMessage) {
            return -1;
          } else {
            return 1;
          }
        }
        //if (`${a.first_name} ${a.last_name}` < `${b.first_name} ${b.last_name}`) return -1
        //if (`${a.first_name} ${a.last_name}` > `${b.first_name} ${b.last_name}`) return 1
        return 0
      })

    },
    onlineUsers() {
      return Users.onlineUsersIds().map(u => u.id)
    },
    filteredUsers() {
      return this.orderedUsers.filter(user => {
        return user.first_name.toLowerCase().match(this.userFilter.toLowerCase()) 
          || user.last_name.toLowerCase().match(this.userFilter.toLowerCase())
      })
    }
  },
  mixins: [conversation]
}
</script>