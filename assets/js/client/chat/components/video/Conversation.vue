<template>
   <modal 
    :name="name"
    :scrollable="true"
    @opened="connectUser()"
    @before-open="beforeOpen"
    :adaptive="true" 
    width="100%" height="100%"
    :reset="true">
    <div class="row">
      <div class="col-md-6">
        <div class="w100 mb-4 px-3 py-2 text-white">
          <video id="local-stream" 
            ref="localStream" 
            autoplay muted>
          </video>
        </div>
      </div>
      <div class="col-md-6">
        <div class="w100 mb-4 px-3 py-2 text-white">
          <video id="remote-stream" 
            ref="remoteStream" autoplay>
          </video>
        </div>
      </div>
      <div id="buttons-container" class="row justify-content-center mt-3" style="bottom: 20px">
        <div class="col-md-2 text-center">
          <button id="mic-btn" type="button" class="btn btn-block btn-secondary btn-lg">
            <i id="mic-icon" class="fas fa-microphone"></i>
          </button>
        </div>
        <div class="col-md-2 text-center">
          <button id="video-btn"  type="button" class="btn btn-block btn-dark btn-lg">
            <i id="video-icon" class="fas fa-video"></i>
          </button>
        </div>
        <div class="col-md-2 text-center">
          <button id="exit-btn"  type="button" 
            class="btn btn-block btn-danger btn-lg"
            @click="disconnect">
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
  props: ['name','connectOnInit', 'offer'],
  methods: {
    mounted() {
      this.setVideoStream(this.$refs.remoteStream, new MediaStream())
    },
    async beforeOpen(event) {
      if (event && event.params && event.params.offer) {
        await this.connect().then(() => {
          this.showRemoteDesc(event.params.offer)
        })
      }
    },
    connectUser() {
      if (this.connectOnInit) {
        this.connect().then(() => {
          this.call().then(() => {
            this.setRemoteStream()
          })
        })
      } else {
        this.setRemoteStream()
      }
      this.$modal.hide(`conversation-${this.callerId}-answer`)
      this.$modal.hide(`answer-${this.callerId}-call`)
    }
  }
}
</script>
