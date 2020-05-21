<template>
  <div class='user-item' @click="toggleSelectedUser">
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
          Hello! Where you are now? I want to talk. Hello! Where you are now? I want to talk
        </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['user'],
  methods: {
    toggleSelectedUser() {
      this.$emit('user:select', user)
    }
  },
  computed: {
    userAvatar() {
      if (!this.user.avatar) return ''
      return this.user.avatar.
        replace(/32/g,"50").
        replace(/16\.0/g, '25.0').
        replace(/13.333333333333334px/g,'18.333333px').
        replace(/67%/g, '63%')
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