<template>
  <div class="cui-github-explore">
    <div class="cui-github-explore-sort clearfix">
      <div class="cui-github-explore-sort-left">
        <div :class='`.DashboardContainer-${consultation.id}`'></div>
        <button class="cui-github-explore-sort-option btn btn-primary"
          :id="`#consultation-upload-${consultation.id}`"
          @click="openUpload">
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
      </div>
    </div>  
  </div>
</template>
<script>
import currentFolder from '../../../file_manager/mixins/currentFolder'
import Downloader from '../../../../ajax-downloader'
import settings from '../../../file_manager/mixins/settings'
import download from '../../../file_manager/mixins/download'
import upload from '../../../file_manager/mixins/upload'
export default {
  props: ['currentFolderId', 'currentFolder', 'consultation'],
  mixins: [
    currentFolder, 
    settings, 
    download, 
    upload, 
  ],
  methods: {
    openUpload() {
      this.uppyInstance.getPlugin('Dashboard').openModal()
    }
  }
}
</script>