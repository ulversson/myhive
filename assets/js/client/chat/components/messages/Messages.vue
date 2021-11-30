<template>
  <div class="card-body" :style="backgroundStyle">
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
  computed: {
    backgroundStyle() {
      if (this.conversation.slug === 'myhive-lobby') {
        return 'background-color: #e6eeff !important'
      } else {
        return ''
      }
    }
  },
  methods: {
    conversationItemList(itemId) {
      let listItem = this.listItem(itemId)
      if (listItem) return listItem[0]
      if (!listItem) return 
    },
    scrollToElement(elem) {
      let element = $(elem)
      const el = element[0]

      if (el) {
        el.scrollIntoView()
      }
    },
  },
  data() {
    return {
      header: 'You are in chat lobby. Type a message and press enter to send it to everyone',
      messages: []
    }
  },
  created() {
    this.$on('new:message', payload => {
      let message = this.messageFromPayload(payload.message)
      let conversationItemList = this.conversationItemList(payload.message.user_id)
      
      if (this.conversation.id === payload.message.conversation_id) {
        this.messages.push(message)
      }
      if (payload.slug !== 'myhive-lobby' && conversationItemList && conversationItemList.user.conv_id === payload.message.conversation_id) {
          conversationItemList.setLastMessage({
            id: message.id,
            content: message.text,
            inserted_at: message.inserted
          })
        conversationItemList.setUnread(payload.unread)
      }
    })
  }
}
</script>