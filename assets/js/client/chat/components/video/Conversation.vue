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
          <av-media :media="remoteAudioStream" 
            v-if="!isVideo"/>
        </div>
      </div>
      <audio id="local-stream" 
        v-if="!isVideo" ref="localStream" autoplay>
      </audio>
      <div class="container h-100">
        <div class="row h-100 justify-content-center align-items-center">
          <form class="col-12">
            <av-media 
              canv-class="mt-3 w-100"
              :media="localAudioStream" 
              :canv-width="600"
              :canv-height="190"
              v-if="!isVideo"/>
          </form>   
        </div>
      </div>
      <ConversationButtons :isVideo="isVideo"/>
    </div>
   </modal>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'
import ConversationButtons from './ConversationButtons.vue'
export default {
  mixins: [ video, chatUser ],
  components: { ConversationButtons },
  props: ['name','connectOnInit', 'offer', 'callerId', 'isAudio', 'isVideo'],
  data() {
    return {
      localAudioStream: null,
      remoteAudioStream: null
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
      if (event && event.params && event.params.timeoutToClear) {
        clearTimeout(event.params.timeoutToClear)
      }
    },
    connectUser(event) {
      if (this.connectOnInit) {
        this.connect(this.isVideo).then(() => {
          this.call().then(() => {
            this.setRemoteStream()
          })
        })
      } else {
        this.setRemoteStream()
      }
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