<template>
  <div class="container h-100">
    <div class="row h-100 justify-content-center align-items-center">
      <audio id="local-stream" 
        ref="localStream" autoplay>
      </audio>
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
</template>