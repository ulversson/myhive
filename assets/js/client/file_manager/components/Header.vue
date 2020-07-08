<template>
  <div class="cui-github-explore">
    <div class="cui-github-explore-sort clearfix">
      <div class="cui-github-explore-sort-left">
        <div class='DashboardContainer'></div>
        <button class="cui-github-explore-sort-option btn btn icon-btn btn-outline-success btn-sm" 
          @click="loadParent()" v-if="hasParent">
          <i class='icmn-arrow-left'></i>&nbsp;
        </button>
        <button class="cui-github-explore-sort-option btn btn-primary btn-sm upload-button">
          <i class='icmn-upload'></i>&nbsp;
          Upload
        </button>
        <button class="cui-github-explore-sort-option btn btn-sm"
          @click="downloadAll()"
          :disabled="this.selectedItems.length === 0"
          :style="this.selectedItems.length === 0 ? 'cursor: not-allowed' : 'cursor: pointer'"
          :class="selectedItemClass">
          <i class='icmn-download'></i>&nbsp;
          Download
        </button>
        <button class="cui-github-explore-sort-option btn-info btn btn-sm"
          @click="share()">
          <i class='fas fa-share-alt'></i>&nbsp;
          Share
        </button>
        <button class="cui-github-explore-sort-option btn btn-sm btn-warning text-white"
          v-if="isRadiologyVisible"
          @click="showRadiology()">
          <i class='fas fa-x-ray'></i>&nbsp;
          Radiology
        </button>
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        ref="rightPanel"
        :currentFolder="currentFolder" />
      <ShareModal />
      <Radiology />
      <AnswerCall 
        :avatar="callingUser.avatar128"
        :userName="callingUser.userName"
        :callerId="callingUser.callerId"
        :isAudio="callingUser.isAudio"
        :isVideo="callingUser.isVideo"
        :user="callingUser.user"
        :name="callingUser.name"/>
    </div>  
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
import currentFolder from '../mixins/currentFolder'
import ShareModal from './sharing/ShareModal.vue'
import Radiology from './radiology/Radiology.vue'
import settings from '../mixins/settings'
import upload from '../mixins/upload'
import download from '../mixins/download'
import externalCall from '../../chat/mixins/externalCall'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder, settings, upload, download, externalCall],
  computed: {
    appModules() {
      return this.$store.state.appModules.map((f) => {
        return f.code
      })
    }, 
    isRadiologyVisible() {
      return this.appModules.includes("radiology")
    }
  },
  methods: {
    share() {
      this.$modal.show('share-modal')
    },
    showRadiology() {
      this.$modal.show('radiology')
    }
  },
  components: { RightPanelActions, ShareModal, Radiology }
}
</script>