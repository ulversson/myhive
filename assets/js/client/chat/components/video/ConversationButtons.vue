<template>
  <div id="buttons-container" class="row justify-content-center mt-3" style="bottom: 20px">
    <div class="col-md-2 text-center">
        <button id="mic-btn" type="button" 
          @click="toggleSound()"
          class="btn btn-block btn-secondary btn-lg">
        <i id="mic-icon" :class="audioIcon"></i>
      </button>
    </div>
    <div class="col-md-2 text-center"
      v-if="isVideo">
      <button id="video-btn"  type="button" 
        @click="toggleVideo()"
          class="btn btn-block btn-dark btn-lg">
          <i id="video-icon" 
          :class="videoIcon"></i>
      </button>
    </div>
    <div class="col-md-2 text-center">
      <button id="exit-btn"  type="button" 
        class="btn btn-block btn-danger btn-lg"
        @click="endConversation()">
        <i id="exit-icon" class="fas fa-phone-slash"></i>
      </button>
    </div>
  </div>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'

export default {
  mixins: [ video, chatUser ],
  props: ['isVideo'],
    data() {
    return {
      videoOn: true,
      soundOn: true,
      videoIcon: 'fas fa-video',
      audioIcon: 'fas fa-microphone'
    }
  },
  computed: {
    conversationStreams() {
      return this.$parent.$parent.$refs
    }
  },
  watch: {
    videoOn: function(newVal, oldVal) {
      this.conversationStreams.localStream.srcObject.getVideoTracks()[0].enabled = newVal
      if (newVal) 
        this.videoIcon = 'fas fa-video'
      else 
        this.videoIcon = 'fas fa-video-slash'
    },
    soundOn: function(newVal, oldVal) {
      this.conversationStreams.localStream.srcObject.getAudioTracks()[0].enabled = newVal
      if (newVal) 
        this.audioIcon = 'fas fa-microphone'
      else 
        this.audioIcon = 'fas fa-microphone-slash'
    }
  },
  methods: {
    toggleSound() {
      this.soundOn = !this.soundOn
    },
    toggleVideo() {
      this.videoOn = !this.videoOn
    }
  }
}
</script>