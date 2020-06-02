<template>
   <div class="form-group mt-4 mb-0">
    <textarea class="form-control adjustable-textarea" 
      placeholder="Type and press enter" 
      v-model="messageText"
      @keypress="send"
      style="overflow: hidden; overflow-wrap: break-word; resize: none; height: 62px;">
    </textarea>
    <div class="mt-3">
      <button class="btn btn-primary width-200"
        @click="sendClick()">
        <i class="fas fa-send mr-2"></i>
        &nbsp;Send
      </button>
      <button class="btn btn-link">
        Attach File
      </button>
    </div>
  </div>
</template>
<script>
import { Socket, Presence } from "phoenix"
import chatUser from '../../mixins/chatUser'
import conversation from '../../mixins/conversation'
export default {
  mixins: [chatUser, conversation],
  mounted() {
    this.connectToRoom('room:lobby')
  },
  data() {
    return {
      messageText: "",
      channel: null,
      socket: null
    }
  },
  methods: {
    send(ev) {
      if (ev.keyCode === 13) {
        this.sendClick()
      }
    },
    sendClick() {
      if (this.messageText !== '') {
         this.channel.push('new_message', {
          name: this.userName,    
          text: this.messageText,
          userId: this.userId,
          avatar: this.avatar,
          conversationId: this.conversationId
        })
        this.messageText = ''
        this.$parent.scrollToElement('.cui-apps-chat-block-item:last')
      }
    }
  }
}
</script>