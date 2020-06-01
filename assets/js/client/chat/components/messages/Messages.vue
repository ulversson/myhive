<template>
  <div class="card-body">
    <div class="cui-apps-messaging">
      <div class="height-700 custom-scroll cui-utils-scrollable">
        <div class="cui-apps-chat-block">
          <span class='text-muted'>
            {{ header }}
          </span>
          <Message 
            :ref="`message-${message.id}`"
            v-for="message in messages" 
            :message="message"
            :key="message.id"/>
        </div>
      </div>
      <MessageForm ref="chatForm"/>
    </div>
  </div>
</template>
<script>
import Message from './Message.vue'
import MessageForm from './MessageForm.vue'
import chatUser from '../../mixins/chatUser'
import conversation from '../../mixins/conversation'
export default {
  mixins: [chatUser, conversation],
  components: {
    Message, MessageForm
  },
  methods: {
    scrollToElement(elem) {
      let element = $(elem)
      const el = element[0]

      if (el) {
        el.scrollIntoView()
      }
    },
  },
  updated() {
    this.scrollToElement('.cui-apps-chat-block-item:last')
  },
  data() {
    return {
      header: 'You are in chat lobby. Type a message and press enter to send it to everyone',
      messages: []
    }
  },
  computed: {
    reversedMessages() {
      return this.messages.reverse()
    }
  },
  created() {
    this.$on('new:message', payload => {
      let message = this.messageFromPayload(payload)
      this.messages.push(message)
    })
  }
}
</script>