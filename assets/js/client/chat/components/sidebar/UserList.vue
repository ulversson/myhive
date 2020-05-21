<template>
  <div class="cui-apps-messaging-list">
    <div class="cui-apps-messaging-tab" 
      v-for="(user) in users" :key="user.id">
      <UserListItem :user="user" ref="userList" />
    </div>
  </div>
</template>
<script>
import UserListItem from './UserListItem.vue'
export default {
  props: ['users'],
  components: { UserListItem },
  created() {
    this.$on('user:select', (user) => {
      alert(user.first_name)
    })
  }
}
</script>