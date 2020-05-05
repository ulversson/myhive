<template>
  <modal 
    :name="`asset-modal-${fileAsset.id}`"
    :min-width="200"
    :min-height="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    @opened="afterOpened"
    width="40%"
    height="auto">
  <div class='card' v-if="isText">
    <div class='card-header'>
      {{ fileAsset.name}}
    </div>
    <div class='card-body'>
      <pre  style="max-height: 360px; overflow-y: scroll; overflow-x: scroll">
      {{txtFileContent}}
      </pre>
    </div>
  </div>
  <vue-plyr v-if="isVideo" ref="player">
    <video>
      <source :src="this.playLink" 
        preload="none" controls  :type="fileAsset.filetype"  size="720"/>
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
  data() {
    return {
      txtFileContent: ''
    }
  },
  methods: {
    afterOpened() {
      if (this.isText) {
        $.get(`/file_asset/${this.fileAsset.id}`, (data) => {
          this.txtFileContent = data
        })
      }
    }
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
