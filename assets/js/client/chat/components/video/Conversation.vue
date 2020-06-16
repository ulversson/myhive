<template>
   <modal 
    :name="name"
    :scrollable="true"
    @opened="connectUser"
    @before-open="beforeOpen"
    @after-close="afterClose"
    :adaptive="true" 
    width="100%" height="100%"
    :reset="true">
    <div class="row no-gutter">
      <div class="col-6">
        <div class="w100 no-gutter text-white">
          <video id="local-stream" 
            v-if="isVideo"
            ref="localStream" 
            style='width: 100%; height: 100%'
            class='w100'
            autoplay muted>
          </video>
          <audio id="local-stream" 
            v-else ref="localStream" autoplay>
          </audio>
          <div class="container h-100">
            <div class="row h-100 justify-content-center align-items-center">
              <form class="col-12">
                <av-media 
                  canv-class="mt-3"
                  :media="localAudioStream" 
                  :type="'frequ'"
                  :canv-width="600"
                  :canv-height="190"
                  v-if="!isVideo"/>
              </form>   
            </div>
          </div>
        </div>
      </div>
      <div class="col-6">
        <div class="w100 text-white">
          <video id="remote-stream" 
            class='w100' style='width: 100%; height: 100%'
            v-if="isVideo"
            ref="remoteStream" autoplay>
          </video>
          <audio id="remote-stream" 
            v-else ref="remoteStream" autoplay>
          </audio>
          <av-media :media="remoteAudioStream" v-if="!isVideo"/>
        </div>
      </div>
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
    </div>
   </modal>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'
export default {
  mixins: [ video, chatUser ],
  props: ['name','connectOnInit', 'offer', 'callerId', 'isAudio', 'isVideo'],
  data() {
    return {
      videoOn: true,
      soundOn: true,
      localAudioStream: null,
      remoteAudioStream: null,
      videoIcon: 'fas fa-video',
      audioIcon: 'fas fa-microphone'
    }
  },
  created() {

  },
  watch: {
    videoOn: function(newVal, oldVal) {
      this.localStream.getVideoTracks()[0].enabled = newVal
      if (newVal) 
        this.videoIcon = 'fas fa-video'
      else 
        this.videoIcon = 'fas fa-video-slash'
    },
    soundOn: function(newVal, oldVal) {
      this.localStream.getAudioTracks()[0].enabled = newVal
      if (newVal) 
        this.audioIcon = 'fas fa-microphone'
      else 
        this.audioIcon = 'fas fa-microphone-slash'
    }
  },
  methods: {
    mounted() {
      this.setVideoStream(this.$refs.remoteStream, new MediaStream())
      this.stopRinging()
    },
    afterClose() {
      this.$modal.hide(`conversation-${this.callerId}-answer`)
      this.$modal.hide(`answer-${this.callerId}-video-call`)
      this.$modal.hide(`answer-${this.callerId}-audio-call`)
    },
    async beforeOpen(event) {
      if (event && event.params && event.params.offer) {
        await this.connect().then(() => {
          this.showRemoteDesc(event.params.offer)
        })
      }
      if (event && event.params && (event.params.isVideo || event.params.isAudio)) {
          this.isAudio = event.params.isAudio
          this.isVideo = event.params.isVideo
      }
    },
    connectUser(event) {
      debugger
      if (this.connectOnInit) {
        this.connect(this.isVideo).then(() => {
          this.call().then(() => {
            this.setRemoteStream()
          })
        })
      } else {
        this.setRemoteStream()
      }
    },
    toggleSound() {
      this.soundOn = !this.soundOn
    },
    toggleVideo() {
      this.videoOn = !this.videoOn
    }
  }
}
</script>
<style scoped>
.no-gutter > [class*='col-'] {
  padding-right:0;
  padding-left:0;
}
</style>