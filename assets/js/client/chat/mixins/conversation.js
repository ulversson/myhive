import { Socket } from "phoenix"

export default {
  data() {
    return {
      messages: []
    }
  },  
  computed: {
    conversation() {
      return this.$store.state.conversation
    },
    conversationId() {
      return this.conversation.id
    },
    chatComponents() {
      return this.$root.$children[0].$refs
    },
    chatMessages() {
      return this.chatComponents.messages.messages
    }
  },
  methods: {
    listItem(itemId) {
      return this.chatComponents
        .sidebar
        .$refs
        .list
        .$refs[`userList-${itemId}`]
    },
    loadChatUsers(room) {
      $.getJSON(`/api/v1/users?conversation=${room}`, (res) => {
        this.users = res.data
        this.$store.commit('setConversation', res.conversation)
      })
    },
    loadMessages() {
      $.getJSON(`/api/v1/chat_messages/${this.conversation.slug}`, (res) =>{
        res.data.forEach((msg) => {
          this.messages.push(
            this.messageFromPayload(msg)
          )
        })             
      })
    },
    messageFromPayload(payload) {
      return {
        name: `${payload.user.first_name} ${payload.user.last_name}`,
        text: payload.content,
        userId: payload.user_id,
        inserted: payload.inserted_at,
        avatar: payload.avatar,
        conversationId: payload.conversation_id
      }
    },
    connectToRoom(room) {
      this.socket = new Socket('/socket', {
        params: {
          user_id: this.userId
        }
      })
      this.socket.connect()
      
      if (this.channel) this.channel.leave()
      this.channel = this.socket.channel(room, {
        user_id: this.userId
      })
      this.channel.join()
      this.channel.on('new_message', (payload) => {
        this.$parent.$emit('new:message', payload)
      })
      this.channel.on('init:msg', (payload) => {
        this.chatComponents.messages.header = ''
        this.chatMessages.splice(0, this.chatMessages.length)
        this.$store.commit('setConversation', payload.conversation)
        payload.messages.forEach((msg) => {
          this.chatMessages.push(
            this.messageFromPayload(msg)
          )
        })  
      })
    }
  }
}