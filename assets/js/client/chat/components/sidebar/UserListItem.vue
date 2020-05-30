<template>
  <div class='user-item' @click="toggleSelectedUser"
    style="height: 48px">
    <div class="cui-apps-messaging-tab-avatar">
      <a class="cui-avatar cui-avatar-50" v-html="userAvatar" />
    </div>
    <div class="cui-apps-messaging-tab-content">
      <small class="cui-apps-messaging-tab-time">8:34PM</small>
        <div class="cui-apps-messaging-tab-name">
          {{ userName }}
          <span :class="isOnline ? 'online-status' : 'offline-status'"
            class='light-style fa fa-circle smaller-40 align-middle'>
          </span>
        </div>  
        <div class="cui-apps-messaging-tab-text">
          Where are you, we need to talk....
        </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['user'],
  methods: {
    toggleSelectedUser() {
      this.$parent.$emit('user:select', this.user)
    }
  },
  computed: {
    userAvatar() {
      if (!this.user.avatar) return ''
      return this.user.avatar
    },  
    userName() {
      return `${this.user.first_name} ${this.user.last_name}`
    },
    onlineIds() {
      return Users.onlineUsersIds().map(u => u.id)
    },
    isOnline() {
      return this.onlineIds.filter(id => id === this.user.id).length > 0
    }
  }
}
</script>