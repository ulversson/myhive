<template>
  <modal 
    :name="`asset-modal-${fileAsset.id}`"
    :min-width="200"
    :min-height="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    width="40%"
    height="auto">
  <pre v-if="isText" style="max-height: 360px; overflow-y: scroll; overflow-x: scroll">
    {{fileAsset.content}}
  </pre>
  <vue-plyr v-if="isVideo" ref="player">
    <video>
      <source :src="this.playLink" 
        preload="auto" controls  :type="fileAsset.filetype"  size="720"/>
    </video>
  </vue-plyr>
  <vue-plyr v-if="isAudio" ref="player">
    <audio>
      <source :src="this.playLink" :type="fileAsset.filetype"/>
    </audio>
  </vue-plyr>    
  </modal>
</template>
<script>
export default {
  props: ['fileAsset'],
  methods: {

  },
  computed: {
    playLink(){
      return this.fileAsset.link
    },
    isVideo() {
      return this.fileAsset.assettype === "video"
    },
    isAudio() {
      return this.fileAsset.assettype === "audio"
    },
    isText() {
      return this.fileAsset.assettype === "text"
    }
  }

}
</script>
