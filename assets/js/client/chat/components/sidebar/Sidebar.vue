<template>
  <div class="cui-utils-card-sidebar">
    <div class="cui-apps-messaging-header">
      <input class="form-control cui-apps-messaging-header-input" 
        placeholder="Search..." 
        v-model="userFilter">
        <i class="icmn-search"></i>
      <button></button>
    </div>
    <UserList :users.sync="filteredUsers"/>
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

        /*const aUnread = self.hasUserUnreadMessages(a);
        const bUnread = self.hasUserUnreadMessages(b);
        if (a_has_unread != b_has_unread) {
          if (a_has_unread) {
            return -1;
          } else {
            return 1;
          }
        }
        if (a.user_name < b.user_name) return -1;
        if (a.user_name > b.user_name) return 1; */
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