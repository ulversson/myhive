<template>
  <modal 
    name="invite-to-chat-room"
    :scrollable="true"
    :adaptive="true" 
    @opened="setupUI"
    width="500" height="330" :reset="true">
  <div class="container h-100">
    <div class="row h-100 justify-content-center align-items-center">
      <form class="col-12">
        <div class="form-group"
          :class="showRoomError ? 'has-danger':''">
          <label class='form-label'>
            Select Chat Room
            <span class='required'>*</span>
          </label>
          <select class="form-control" 
            id="chat-room-search"
            v-model="selectedChatRoom"
            @change="loadUsersForConversation"
            placeholder="Select chat room to invite users into.">
            <option :value="conv.id"
              v-for="conv in conversations" :key="conv.id">
              {{conv.title}}
            </option>
          </select>
          <span class='help-block' v-if="showRoomError">
            This field is mandatory
          </span>
        </div>
        <div class="form-group"
          :class="showUserError ? 'has-danger':''">
          <label class='form-label'>
            Select users
            <span class='required'>*</span>
          </label>
          <select class="form-control" 
            data-url="/api/v1/users/search"
            v-model="userIds" id="user-search"
            :disabled="!selectedChatRoom"
            placeholder="Select users for this chat room.">
          </select>
          <span class='help-block' v-if="showUserError">
            You must select at least one user (other than yourself)
          </span>
          <small class='text-muted help-block'>
            Only you and users selected here will have an access to this chat room. You can invite more users later
          </small>
        </div>
        <div class="form-actions">
          <div class="form-group row" style="float: right; margin-right: 0px;">
            <div class="pull-left">
              <a href="javascript:void(0)"
                @click="hideModal()" class="btn btn-sm btn-default">
                CANCEL&nbsp;<i class='fa fa-ban'></i>
              </a>
              <a @click="updateChatRoom()"
                class="btn btn-sm btn-primary">
                SAVE&nbsp;<i class='far fa-save'></i>
              </a>
            </div>
          </div>
        </div>
      </form>   
    </div>
  </div>
  </modal>
</template>
<script>
import chatUser from '../../mixins/chatUser'
import roomManager from '../../mixins/roomManager'
export default {
  mixins: [chatUser, roomManager],
  props: {
    selectedChatRoom: {
      type: Number, 
      default: 0
    },
    conversations: {
      type: Array, 
      default: () => []
    },
    userIds: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    selectName() {
      return "select#user-search"
    }, 
    showRoomError() {
      return this.submit && this.selectedChatRoom === undefined
    },
    formValid() {
      return !(this.showRoomError && this.showUserError)
    },
    formData() {
      return {
        id: this.selectedChatRoom,
        user_ids: this.selectValues()
      }
    }
  },
  methods: {
    getUserIdsForConversation() {
      let filtered = this.conversations.filter(c => c.id === this.selectedChatRoom)
      if (filtered.length === 0) return []
      return filtered[0].users_ids
    },
    loadUsersForConversation(id) {
      this.triggerSelect2Change()
      let ids = this.getUserIdsForConversation()
      if (ids.length === 0) return
      $.getJSON(`/api/v1/users/for_select?ids=${ids.join(',')}`, (jsonResponse) => {
        jsonResponse.forEach((element, index) => {
          this.addOptionElement(element)
          this.clearSelect2Error()
        })
      })
    },
    addOptionElement(element) {
      let fullName = `${element.first_name} ${element.last_name}`
      let option = new Option(fullName, element.id, true, true)
      $('select#user-search').append(option)
    },
    updateChatRoom() {
      this.submit = true
      if (this.formValid) {
        $.ajax({
          type: 'PUT',
          data: this.formData,
          url: `/api/v1/chat_rooms/${this.selectedChatRoom}`
        }).done((jsonRes) =>{
          if (jsonRes.success) {
            window.location.reload(true)
          }
        })
      }
    },
    hideModal() {
      this.$modal.hide('invite-to-chat-room')
    },
    reset() {
      this.submit = false
    },
    setupUI() {
      this.bindSelect2UserEvents(true)
      this.reset()
      this.loadUsersForConversation(this.selectedChatRoom)
    } 
  }
}
</script>