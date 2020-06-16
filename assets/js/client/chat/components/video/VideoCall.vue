<template>
  <div class='row'>
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
        </div>
      </div>
  </div>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'

export default {
  mixins: [ video, chatUser ],
  props: ['isVideo']
}
</script>