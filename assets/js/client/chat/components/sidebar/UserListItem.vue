<template>
  <div class='user-item' @click="toggleSelectedUser"
    style="height: 48px">
    <div class="cui-apps-messaging-tab-avatar">
      <a class="cui-avatar cui-avatar-50" v-html="userAvatar" />
    </div>
    <div class="cui-apps-messaging-tab-content">
      <small class="cui-apps-messaging-tab-time">{{lastMessageDate}}</small>
        <div class="cui-apps-messaging-tab-name">
          {{ userName }}
          <span :class="isOnline ? 'online-status' : 'offline-status'"
            class='light-style fa fa-circle smaller-40 align-middle'>
          </span>
          <span 
            v-if="user.unread.length > 0"
            class='badge badge-outline badge-pill badge-primary unread-count' 
            :data-id="user.id">
            {{ user.unread.length }}
          </span> 
        </div>  
        <div class="cui-apps-messaging-tab-text">
          {{ lastMessage  }} 
        </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  props: ['user'],
  methods: {
    toggleSelectedUser() {
      this.$parent.$emit('user:select', this.user)
      this.readMessages(this.user)
    },
    setLastMessage(message) {
      this.user.last_message = message
    },
    readMessages() {
      this.user.unread.splice(0, this.user.unread.length)
      //$(`span.unread-count[data-id=${user.id}]`).remove()
    },
    setUnread(unreadItems) {
      this.user.unread = unreadItems
    }
  },
  computed: {
    userAvatar() {
      if (!this.user.avatar) return ''
      return this.user.avatar
    },  
    lastMessage() {
      if (this.user.last_message) {
        return this.user.last_message.content
      } else {
        return ''
      }
    },
    userName() {
      return `${this.user.first_name} ${this.user.last_name}`
    },
    onlineIds() {
      return Users.onlineUsersIds().map(u => u.id)
    },
    isOnline() {
      return this.onlineIds.filter(id => id === this.user.id).length > 0
    },
    lastMessageDate() {
      if (!this.user.last_message) return {}
      if (Object.keys(this.user.last_message).length === 0) return ''
      return moment(this.user.last_message.inserted_at)
        .tz('Europe/London').fromNow();  
    }
  }
}
</script>