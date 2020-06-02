<template>
  <div class="cui-apps-messaging-list">
    <div class="cui-apps-messaging-tab" 
      :class="isSelected(user.id) ? 
        'cui-apps-messaging-tab-selected': ''"
      v-for="(user) in users" :key="user.id">
      <UserListItem :user="user" 
        @click="readMessages(user)"
        :ref="`userList-${user.id}`" 
        :selected="selected" />
    </div>
  </div>
</template>
<script>
import UserListItem from './UserListItem.vue'
import conversation from '../../mixins/conversation'
import chatUser from '../../mixins/chatUser'
export default {
  mixins: [conversation, chatUser],
  props: ['users'],
  components: { UserListItem },
  data() {
    return {
      selected: 0
    }
  },
  created() {
    this.$on('user:select', (user) => {
      this.selected = user.id
      let roomId = this.userRoom(this.selected)
      this.connectToRoom(roomId)
    })
  }, 
  methods: {
    userRoom() {
      return `room:${this.userId}:${this.selected}`
    },
    isSelected(id) {
      return this.selected === id
    }
  }
}
</script>