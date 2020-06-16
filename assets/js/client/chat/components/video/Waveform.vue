<template>
  <div class="container h-100">
    <div class="row h-100 justify-content-center align-items-center">
      <form class="col-12">
        <av-media 
          canv-class="mt-3"
          :media="localAudioStream" 
          :canv-width="600"
          :canv-height="190"/>       
       </form>   
    </div>
  </div>
</template>
<script>
import video from '../../mixins/video'
import chatUser from '../../mixins/chatUser'

export default {
  mixins: [ video, chatUser ],
  props: ['isVideo', 'localAudioStream']
}
</script>