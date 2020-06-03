<template>
  <div class="card-header">
    <div class="pull-right">
      <div class="dropdown mt-2 d-inline-block pull-right" style='float: right'>
        <a href="" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          <i class="icmn-database mr-2"></i>
          <span class="hidden-lg-down">Actions</span>
          <span class="caret"></span>
        </a>
        <div class="dropdown-menu dropdown-menu-right" role="menu">
          <div class="dropdown-header">Chat Rooms</div>
          <a class="dropdown-item" 
            href="javascript:void(0)"
            @click="addNewChatRoom()">Create</a>
          <a class="dropdown-item" href="javascript:void(0)">Join</a>
          <a class="dropdown-item" href="javascript:void(0)">Invite</a>
          <div class="dropdown-header">Public</div>
          <a class="dropdown-item" href="javascript:void(0)"
           @click="connectLobbyAndDeselect()">myHive Lobby</a>
          <div class="dropdown-divider"></div>
        </div>
      </div>
    </div>
    <h4 class="mt-1 mb-1 text-black">
      <strong>{{ conversation.title }}</strong>
    </h4>
  </div>
</template>
<script>
import conversation from '../../mixins/conversation'
import chatUser from '../../mixins/chatUser'
export default {
  methods: {
    connectLobbyAndDeselect() {
      this.connectToRoom('room:lobby')
      this.chatComponents.sidebar.$refs.list.selected = 0
    }
  },
  mixins: [conversation, chatUser],
  methods: {
    addNewChatRoom() {
      this.$modal.show('newChatRoom')
    }
  }
}
</script>