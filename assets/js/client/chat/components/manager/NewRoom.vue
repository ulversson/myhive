<template>
  <modal 
    name="new-chat-room"
    :scrollable="true"
    :adaptive="true" 
    @opened="setupUI"
    width="500" height="330" :reset="true">
  <div class="container h-100">
    <div class="row h-100 justify-content-center align-items-center">
      <form class="col-12">
        <div class="form-group"
          :class="showNameError ? 'has-danger':''">
          <label class='form-label'>
            Chat Room Name
            <span class='required'>*</span>
          </label>
          <input type="text" class="form-control" 
            placeholder="Please enter room name..."
            v-model="roomName">
          <span class='help-block' v-if="showNameError">
            This field is mandatory
          </span>
          <small class='text-muted help-block'>
            Make sure name is uniqe across the system
          </small>
        </div>
        <div class="form-group"
          :class="showUserError ? 'has-danger':''">
          <label class='form-label'>
            Select users
            <span class='required'>*</span>
          </label>
          <select class="form-control" 
            data-url='/api/v1/users/search'
            v-model="userIds" id="user-search"
            placeholder="Select users for this chat room." />
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
              <a @click="saveChatRoom()"
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
  data() {
    return {
      roomName: "",
      userIds: []
    }
  },
  computed: {
    showNameError() {
      return this.submit && this.roomName === ""
    },
    formValid() {
      return !(this.showNameError && this.showUserError)
    },
    formData() {
      let ids = [...this.selectValues(), ...[this.senderId]]
      return {
        chat_room: {
          title: this.roomName
        },
        user_ids: ids
      }
    }
  },
  methods: {
    saveChatRoom() {
      this.submit = true
      if (this.formValid) {
        $.ajax({
          type: 'POST',
          data: this.formData,
          url: '/api/v1/chat_rooms'
        }).done((jsonRes) =>{
          if (jsonRes.success) {
            window.location.reload(true)
          }
        })
      }
    },
    hideModal() {
      this.$modal.hide('new-chat-room')
    },
    reset() {
      this.roomName = ''
      this.submit = false
      this.clearSelect2Error()
      this.triggerSelect2Change()
    },
    setupUI() {
      this.bindSelect2UserEvents(true)
      this.reset()
    } 
  }
}
</script>