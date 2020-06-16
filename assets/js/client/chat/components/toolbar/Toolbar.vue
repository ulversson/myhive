<template>
  <div class="card-header">
    <div class="pull-right">
      <div class="dropdown mt-2 d-inline-block pull-right" 
        v-if="isAdmin" style='float: right'>
        <a href="" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          <i class="fas fa-comments"></i>
          <span class="hidden-lg-down">Manage</span>
          <span class="caret"></span>
        </a>
        <div class="dropdown-menu dropdown-menu-right" role="menu">
          <div class="dropdown-header">Chat Rooms</div>
          <a class="dropdown-item" 
            href="javascript:void(0)"
            @click="addNewChatRoom()">Create</a>
          <a class="dropdown-item" href="javascript:void(0)">Invite</a>
        </div>
      </div>
      <div class="dropdown mt-2 d-inline-block pull-right" 
        style='float: right'>
        <a href="" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          <i class="fas fa-comments"></i>
          <span class="hidden-lg-down">Your Chat Rooms</span>
          <span class="caret"></span>
        </a>
        <div
          class="dropdown-menu dropdown-menu-right" role="menu">
          <a v-for="conv in conversations" 
            @click="connectAndLoadRoom(conv.slug)"
            :key="conv.id"  class="dropdown-item" href="javascript:void(0)">
            {{ conv.title }}
          </a>
          <div class="dropdown-header">Public</div>
          <a @click="connectLobbyAndDeselect()"
            class="dropdown-item" href="javascript:void(0)">
            myHive Lobby
          </a>
        </div>
      </div>   
    </div>
    <h4 class="mt-1 mb-1 text-black">
      <strong>{{ conversation.title }}</strong>
    </h4>
    <NewRoom />
  </div>
</template>
<script>
import conversation from '../../mixins/conversation'
import chatUser from '../../mixins/chatUser'
import shared from '../../../medico_legal_cases/mixins/shared'
import NewRoom from '../manager/NewRoom.vue'
export default {
  data() {
    return {
      conversations: []
    }
  },
  created() {
    $.getJSON(`/api/v1/chat_rooms/${this.senderId}`,  (res) => {
      res.data.forEach((conv, index) => {
        this.conversations.push(conv)
      })
    })
  },
  mixins: [conversation, chatUser, shared],
  components: { NewRoom },
  computed: {
    showConversations() {
      return this.conversations.length > 0
    }
  },
  methods: {
    connectLobbyAndDeselect() {
      this.connectToRoom('room:lobby')
      this.loadChatUsers('myhive-lobby', true)
      this.chatComponents.sidebar.$refs.list.selected = 0
    },
    connectAndLoadRoom(slug) {
      this.connectToRoom(`group_room:${slug}`)
      this.loadChatUsers(slug, true)
    },
    addNewChatRoom() {
      this.$modal.show('new-chat-room')
    }
  }
}
</script>