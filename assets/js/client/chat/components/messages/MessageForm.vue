<template>
   <div class="form-group mt-4 mb-0">
    <div class='uprogress'></div> 
    <textarea class="form-control adjustable-textarea" 
      placeholder="Type and press enter" 
      v-model="messageText"
      @keypress="send"
      style="overflow: hidden; overflow-wrap: break-word; resize: none; height: 62px;">
    </textarea>
    <div class="mt-3">
      <button class="btn btn-primary width-200"
        :disabled="messageText.trim().length === 0"
        @click="sendClick()">
        <i class="fas fa-send mr-2"></i>
        &nbsp;Send
      </button>
      <button class="btn btn-link" 
        data-toggle="tooltip" 
        data-title="Attach file">
        <i class='fas fa-paperclip fa-2x' @click="attach()"></i>
      </button>
      <div class='chat-form'>
      </div>
      <div class='last-attachment badge badge-pill badge-info' 
        v-if="lastAttachment" style='font-size: 14px'>
        <i :class='lastAttachment.icon'></i>
        &nbsp;{{ lastAttachment.filename }}
      </div>
    </div>
  </div>
</template>
<script>
import { Socket, Presence } from "phoenix"
import chatUser from '../../mixins/chatUser'
import conversation from '../../mixins/conversation'
import video from '../../mixins/video'
import uploader from '../../mixins/uploader'
export default {
  mixins: [chatUser, conversation, video, uploader],
  mounted() {
    this.connectToRoom('room:lobby')
    this.setupVideoChannel(this.socket)
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
        let message = {
          name: this.userName,    
          text: this.messageText,
          userId: this.userId,
          avatar: this.avatar,
          conversationId: this.conversationId
        }
        if (this.lastAttachment) {
          message.attachment_id = this.lastAttachment.id
        }
        this.channel.push('new_message', message)
        this.messageText = ''
        this.$parent.scrollToElement('.cui-apps-chat-block-item:last')
        this.lastAttachment = null
      }
    }
  }
}
</script>
<style type='text/css'>
.chat-form .uppy-FileInput-btn {
  display: none
}
</style>