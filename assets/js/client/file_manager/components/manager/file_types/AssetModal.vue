<template>
  <modal 
    :name="currentModalId"
    :min-width="200"
    :min-height="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    @opened="afterOpened"
    width="40%"
    height="auto">
  <div class='card'>
    <div class='card-header'>
      {{ fileAsset.name}}
    </div>
    <div class='card-body'>
      <pre  v-if="isText" style="max-height: 360px; overflow-y: scroll; overflow-x: scroll" >
        {{txtFileContent}}
      </pre>
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
      <button class='btn btn-primary pull-right mt-2' style='float: right' 
        @click="hideModal">
        <i class="far fa-times-circle"></i>&nbsp;Close
      </button>
    </div>
  </div>    
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
    },
    hideModal() {
      this.$modal.hide(this.currentModalId)
    }
  },
  computed: {
    currentModalId() {
      return `asset-modal-${this.fileAsset.id}`
    },
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
