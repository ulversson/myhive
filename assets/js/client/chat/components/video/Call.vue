<template>
  <modal 
    :name="name"
    :scrollable="true"
    @opened="callUser()"
    @before-open="beforeOpen"
    :adaptive="true" 
    width="400" height="auto"
    :reset="true">
    <div class="call">
      <div>
        <figure class="mb-4 avatar avatar-xl"
          style="margin-top: 10px"
          v-html="this.user.avatar128">
        </figure>
        <h4 class='text-secondary'>
          <span class="text-success">Calling...</span>
          {{ convName }} 
        </h4>
        <div class="action-button mb-3">
          <button type="button" 
            @click="hideModal()"
            class="btn btn-danger btn-floating btn-lg" data-dismiss="modal">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
          </button>
         </div>
      </div>
    </div>
    <Conversation ref="conv" 
      :name="`conversation-${callerId}-call`"
      :connectOnInit="false"
      :isAudio="isAudio"
      :isVideo="isVideo"
      :user="user" 
      :timeoutToClear="timeoutToClear"
      :callerId="callerId"
    />
  </modal>
</template>
<script>
import { Socket } from 'phoenix'
import AnswerCall from './AnswerCall.vue'
import Conversation from './Conversation.vue'
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'
export default {
  props: ['user', 'isAudio', 'isVideo', 'name', 'callerId', 'timeoutToClear'],
  mixins: [video, chatUser],
  computed: {
    convName() {
      return `${this.user.first_name} ${this.user.last_name}`
    }
  },
  components: { AnswerCall, Conversation } ,
  methods: {
    beforeOpen(event) {
      if (event && event.params && (event.params.isVideo || event.params.isAudio)) {
        this.isAudio = event.params.isAudio
        this.isVideo = event.params.isVideo
      }
      if (event && event.params && event.params.timeoutToClear) {
        window.localStorage.setItem('timeout', event.params.timeoutToClear)
      }
    },
    callUser() {
      let timeout = parseInt(window.localStorage.getItem('timeout'))
      this.callUserWithModal(timeout)
    },
    hideModal() {
      this.$modal.hide(this.name)
      this.disconnect()
    }
  }
}
</script>