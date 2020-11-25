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
      </div>
      <right-panel-actions 
        :currentFolderId="currentFolderId"
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
import RightPanelActions from '../../file_manager/components/RightPanelActions.vue'
import NewFolder from '../../file_manager/components/actions/NewFolder.vue'
import currentFolder from '../../file_manager/mixins/currentFolder'
import Downloader from '../../../ajax-downloader'
import settings from '../../file_manager/mixins/settings'
import download from '../../file_manager/mixins/download'
import upload from '../../file_manager/mixins/upload'
import externalCall from '../../chat/mixins/externalCall'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [
    currentFolder, 
    settings, 
    download, 
    upload, 
    externalCall,
  ],
  components: { RightPanelActions, NewFolder }
}
</script>