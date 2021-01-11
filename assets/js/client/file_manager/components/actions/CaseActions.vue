<template>
  <div class="dropdown cui-github-explore-sort-option case-actions">
    <ShareModal />
    <NewFolder :currentFolder="currentFolder" 
      v-show="false" ref="newFolder"/>
    <Send :currentFolder="currentFolder" />
    <button type="button"
      class="btn dropdown-toggle btn-actions"
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
        <li style="line-height: 35px" class='send-email'>
          <a class="dropdown-item"
            v-if="isAdmin && oauth2.microsoft"
            title="Send email from system template"
            data-toggle="tooltip"
            @click="sendEmail()">
            <i class='icmn-envelop'></i>&nbsp;
          Send email...
        </a>
        </li>
        <li style="line-height: 35px">
        <a class="dropdown-item"
          v-if="isAdmin"
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
import { mapState } from 'vuex'
import settings from '../../mixins/settings'
import currentFolder from '../../mixins/currentFolder'
import upload from '../../mixins/upload'
import download from '../../mixins/download'
import Radiology from '../radiology/Radiology.vue'
import ShareModal from '../sharing/ShareModal.vue'
import Consultations from '../consultations/Consultations.vue'
import NewFolder from '../actions/NewFolder.vue'
import Send from '../email_templates/Send.vue'
export default {
  props: ['currentFolderId', 'currentFolder', 'isAdmin'],
  mixins: [currentFolder, settings, upload, download],
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  computed: {
    ...mapState(['oauth2'])
  },
  methods: {
    share() {
      this.$modal.show('share-modal')
    },
    addNewFolder() {
      this.$refs.newFolder.promptNewFolder('Add new folder')
    },
    sendEmail() {
      this.$modal.show('email-modal')
    }
  },
  components: {
    Radiology, ShareModal, Consultations, 
    NewFolder, Send
  }
}
</script>
