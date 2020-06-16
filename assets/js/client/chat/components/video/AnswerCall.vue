<template>
  <modal 
    :name="callName"
    :scrollable="true"
    :adaptive="true" 
    @before-open="beforeOpen"
    width="400" height="auto"
    :reset="true">
    <div class="call">
      <div>
        <figure class="mb-4 avatar avatar-xl"
          style="margin-top: 10px"
          v-html="avatar">
        </figure>
        <h4 class='text-secondary'>
          {{ userName }} 
          <span class="text-success">is calling...</span>
        </h4>
        <div class="action-button mb-3">
          <button type="button" 
            @click="hideModal()"
            class="btn btn-danger btn-floating btn-lg m" data-dismiss="modal">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" 
              viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" 
              stroke-linejoin="round" class="feather feather-x"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
          </button>
          <button @click="showConversation()" type="button" class="btn btn-success btn-pulse btn-floating btn-lg">
            <svg xmlns="http://www.w3.org/2000/svg" 
              width="24" height="24" viewBox="0 0 24 24" fill="none"   
              stroke="currentColor" stroke-width="2" 
              stroke-linecap="round" stroke-linejoin="round" class="feather feather-phone"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
          </button>
         </div>
      </div>
    </div>
    <Conversation ref="conv-audio" 
      :name="`conversation-${callerId}-answer`"
      :connectOnInit="true"
      :isVideo.sync="isVideo"
      :isAudio.sync="isAudio"
      :user="user" 
      :callerId="callerId"/>
  </modal>
</template>
<script>
import video from '../../mixins/video'
import Conversation from '../video//Conversation.vue'
export default {
  props: ['user', 'isAudio', 'isVideo',
    'name', 'avatar', 'callerId'],
  mixins: [video],
  components: {Conversation},
  computed: {
    callName() {
      if (this.isVideo)
        return `answer-${this.user.id}-video-call`
      else
        return `answer-${this.user.id}-audio-call`
    },
    userName() {
      return `${this.user.first_name} ${this.user.last_name}`
    }
  },
  methods: {
    beforeOpen(event) {
      if (event && event.params && (event.params.isVideo || event.params.isAudio)) {
        this.isAudio = event.params.isAudio
        this.isVideo = event.params.isVideo
      }
    },
    showConversation() {
      this.$modal.show(`conversation-${this.callerId}-answer`, {
        isAudio: this.isAudio,
        isVideo: this.isVideo
      })
    },
    hideModal() {
      this.$modal.hide(this.name)
      this.hangup(this.callerId)
      this.disconnect()
    }
  }
}
</script>