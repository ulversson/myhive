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
        <NewFolder :currentFolder="currentFolder"/>
        <a class="cui-github-explore-sort-option btn share-button btn icon-btn btn-sm"
          title="Share files from this case via email"
          data-toggle="tooltip"
          @click="share()">
          <i class='fas fa-share-alt'></i>&nbsp;
          Share
        </a>
        <a class="cui-github-explore-sort-option btn btn-sm text-white"
          v-if="isRadiologyVisible"
          :class="radiologyButtonClass"
          :title="radiologyTitle"
          data-toggle="tooltip"
          data-placement="top"
          :disabled="isRadiologyButtonEnabled === false"
          :style="isRadiologyButtonEnabled === false ? 'cursor: not-allowed' : 'cursor: pointer'"
          @click="showRadiology()">
          <i class='fas fa-x-ray'></i>&nbsp;
          Radiology
        </a>
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        ref="rightPanel"
        :currentFolder="currentFolder" />
      <ShareModal />
      <Radiology ref='radiology'/>
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
import NewFolder from './actions/NewFolder.vue'
import Radiology from './radiology/Radiology.vue'
import settings from '../mixins/settings'
import upload from '../mixins/upload'
import download from '../mixins/download'
import externalCall from '../../chat/mixins/externalCall'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder, settings, upload, download, externalCall],
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  computed: {
    appModules() {
      return this.$store.state.appModules.map((f) => {
        return f.code
      })
    }, 
    isRadiologyVisible() {
      return this.appModules.includes("radiology")
    },
    isRadiologyButtonEnabled() {
      return true
    },
    radiologyTitle() {
      if (this.isRadiologyButtonEnabled === false) 
        return 'No radiology supplied by instructing solicitors; please notify the team if you need sight of any radiology'  
      else 
        return 'Browse Radiology'
    },
    radiologyButtonClass() {
      if (this.isRadiologyButtonEnabled === false) 
        return  'btn-default' 
      else 
        return 'btn-warning'
    }
  },
  methods: {
    share() {
      this.$modal.show('share-modal')
    },
    showRadiology() {
      if (this.isRadiologyButtonEnabled) {
        this.$modal.show('radiology')
      } else 
        return
    }
  },
  components: { RightPanelActions, ShareModal, Radiology, NewFolder }
}
</script>
<style scoped>
.share-button {
  background: #ba04ba; 
  color: white;
  margin-right: 6.89px;
  border: 1px solid #ba04ba
}
.share-button:hover {
  color: white;
  background: #930393;
}
</style>