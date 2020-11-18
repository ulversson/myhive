<template>
  <div class="cui-github-explore">
    <div class="cui-github-explore-sort clearfix">
      <div class="cui-github-explore-sort-left">
        <div class='DashboardContainer'></div>
        <button class="cui-github-explore-sort-option btn btn icon-btn btn-outline-success" 
          @click="loadParent()" v-if="hasParent">
          <i class='icmn-arrow-left'></i>&nbsp;
        </button>
        <button class="cui-github-explore-sort-option btn btn-primary upload-button">
          <i class='icmn-upload'></i>&nbsp;
          Upload
        </button>
        <button class="cui-github-explore-sort-option btn"
          @click="downloadAll()"
          :disabled="this.selectedItems.length === 0"
          :style="this.selectedItems.length === 0 ? 'cursor: not-allowed' : 'cursor: pointer'"
          :class="selectedItemClass">
          <i class='icmn-download'></i>&nbsp;
          Download
        </button>
        <NewFolder :currentFolder="currentFolder"/>
        <CaseActions :currentFolder="currentFolder" />
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        ref="rightPanel"
        :currentFolder="currentFolder" />
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
import CaseActions from './actions/CaseActions.vue'
import settings from '../mixins/settings'
import upload from '../mixins/upload'
import download from '../mixins/download'
import externalCall from '../../chat/mixins/externalCall'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder, settings, upload, download, externalCall],
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  components: { RightPanelActions, NewFolder, CaseActions }
}
</script>