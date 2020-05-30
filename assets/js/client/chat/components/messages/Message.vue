<template>
  <div class="cui-apps-chat-block-item clearfix"
    :class="messageClass" ref="messages">
    <div class="cui-apps-chat-block-avatar">
      <a class="cui-avatar cui-avatar-50" 
        href="javascript:void(0);"
        v-html="message.avatar">
      </a>
    </div>
    <div class="cui-apps-chat-block-content">
      <strong>{{ message.name }} </strong>
      <p>{{ message.text }}</p>
    </div>
  </div>  
</template>
<script>
import chatUser from '../../mixins/chatUser'
export default {
  props: ['message'],
  mixins: [chatUser],
  computed: {
    messageClass() {
      return this.message.userId === this.userId ? 'cui-apps-chat-block-item-right': ''
    }
  }
}
</script>