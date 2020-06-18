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
      <small class="text-right pull-right text-muted" 
        style="float: right;">
        Sent:&nbsp;{{ sentDate }}
      </small>
      <p>{{ message.text }}</p>
      <MessageAttachment 
        :message="message"
        v-if="message.filename" />  
    </div>
  </div>  
</template>
<script>
import moment from 'moment-timezone'
import chatUser from '../../mixins/chatUser'
import MessageAttachment from './MessageAttachment.vue'
export default {
  props: ['message'],
  mixins: [chatUser],
  components: { MessageAttachment },
  computed: {
    messageClass() {
      return this.message.userId === this.userId ? 'cui-apps-chat-block-item-right': ''
    },
    sentDate() {
      return moment(this.message.inserted_at)
        .tz('Europe/London')
        .format("DD/MM/YYYY HH:mm:ss")
    }
  }
}
</script>