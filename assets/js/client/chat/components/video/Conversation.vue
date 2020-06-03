<template>
   <modal 
    :name="name"
    :scrollable="true"
    @opened="connectUser()"
    :adaptive="true" 
    width="100%" height="100%"
    :reset="true">
    <label for="local-stream">Local</label>
    <video id="local-stream" ref="localStream" autoplay muted></video>
    <label for="remote-stream">Remote Video Stream</label>
    <video id="remote-stream" ref="remoteStream" autoplay></video>
    <button id="disconnect" @click="disconnect">Disconnect</button>
   </modal>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'
export default {
  mixins: [ video, chatUser ],
  props: ['name','connectOnInit'],
  methods: {
    connectUser() {
      if (this.connectOnInit) {
        this.connect().then(() => {
          this.call()
        })
      } else {
        this.setRemoteStream()
      }
    }
  }
}
</script>
