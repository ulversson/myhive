<template>
  <div class="dropdown cui-github-explore-sort-option case-actions">
      <ShareModal />
      <NewFolder :currentFolder="currentFolder" v-show="false" ref="newFolder"/>
      <button type="button"
        class="btn dropdown-toggle btn-info"
        style="height: 39.84px;"
        data-toggle="dropdown"
        aria-expanded="false">
        Case actions
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <li style="line-height: 35px">
          <a class="dropdown-item"
            data-toggle="tooltip"
            data-placement="top"
            @click="addNewFolder()">
            <i class='fas fa-folder-plus'></i>&nbsp;
            Add new folder...
          </a>
        </li>
        <li style="line-height: 35px" class="upload">
          <a class="dropdown-item upload-button">
            <i class='icmn-upload'></i>&nbsp;
            Upload
          </a>
        </li>
        <li  style="line-height: 35px" class='download'>
          <a class="dropdown-item"
            @click="downloadAll()"
            :disabled="this.selectedItems.length === 0"
            :style="this.selectedItems.length === 0 ? 'cursor: not-allowed' : 'cursor: pointer'"
            :class="selectedItemClass">
            <i class='icmn-download'></i>&nbsp;
            Download 
          </a>
        </li>
        <li style="line-height: 35px">
        <a class="dropdown-item"
          title="Share files from this case via email"
          data-toggle="tooltip"
          @click="share()">
          <i class='fas fa-share-alt'></i>&nbsp;
          Share...
        </a>
        </li>
      </ul>
  </div>
</template>
<script>
import settings from '../../mixins/settings'
import currentFolder from '../../mixins/currentFolder'
import upload from '../../mixins/upload'
import download from '../../mixins/download'
import Radiology from '../radiology/Radiology.vue'
import ShareModal from '../sharing/ShareModal.vue'
import Consultations from '../consultations/Consultations.vue'
import NewFolder from '../actions/NewFolder.vue'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder, settings, upload, download],
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  methods: {
    share() {
      this.$modal.show('share-modal')
    },
    addNewFolder() {
      this.$refs.newFolder.promptNewFolder('Add new folder')
    }
  },
  components: {
    Radiology, ShareModal,Consultations, NewFolder
  }
}
</script>
<style scoped>

.case-actions .dropdown-menu a:hover {
  color: #fff !important;
  background: #ba04ba; 
  border: 1px solid #ba04ba
}
.case-actions .dropdown-menu a:active {
  color: #fff !important;
  border: 1px solid #ba04ba
}

.case-actions .dropdown-menu li.upload a:hover {
  background-color: #0190fe;
  border-color: #0190fe;
}

.case-actions .dropdown-menu li:first-child a:hover {
  color: #fff !important;
  background-color: #fb434a;
  border-color: #fb434a;
}
.case-actions .dropdown-menu li:first-child a:active {
  color: #fff !important;
  background-color: #fb434a;
  border-color: #fb434a;
}
.case-actions .dropdown-menu li.download a:hover,
.case-actions .dropdown-menu li.download a:active {
  background-color: #46be8a;
  border-color: #46be8a;
}
</style>