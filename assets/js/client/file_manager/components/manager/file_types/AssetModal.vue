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
    {{fileAsset.link.data.content}}
  </pre>
  <vue-plyr v-show="isVideo" ref="player">
    <video>
      <source :src="fileAsset.link" 
        preload="none" controls 
        :type="fileAsset.filetype" 
        size="720">
    </video>
  </vue-plyr>
  <vue-plyr v-show="isAudio" ref="player">
    <audio>
      <source :src="fileAsset.link" :type="fileAsset.filetype"/>
    </audio>
  </vue-plyr>    
  </modal>
</template>
<script>
export default {
 
  mounted() {
    if (this.showModal && (this.isVideo || this.isAudio)) {
      //this.player = this.$refs.player.player 
      //this.player.play()
    }
  },
  props: ['fileAsset'],
  methods: {
     showSelf() {
      this.showModal = true
    },
    hideSelf() {
      this.showModal = false
    }
  },
  data() {
    return {
      showModal: true,
      player: null
    }
  },
  computed: {
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
