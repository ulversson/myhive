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
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        ref="rightPanel"
        :currentFolder="currentFolder" />
    </div>  
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
import currentFolder from '../mixins/currentFolder'
import Tus from '@uppy/tus'
import Downloader from '../../../ajax-downloader'
//import Pace from 'pace-js'
import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload'
import Dashboard from '@uppy/dashboard'

export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder],
  computed: {
    selectedItemClass() {
      return this.selectedItems.length === 0 ? 'btn-default' : 'btn-success'
    },
    downloadFileName() {
      return `archive_${moment().format('LLLL').replace(/,/g,"").replace(/\s/g,"_")}.zip`
    }
  },
  data() {
    let vm = this
    return {
      selectedItems : this.$store.state.selectedItems,
      uppy: Uppy({
        debug: true,
        onBeforeUpload (files) {
          for (const [key, file] of Object.entries(files)) {
            if (!file.meta.folder_id) {
              file.meta.folder_id = vm.currentFolderId
            }
          }
        },
        autoProceed: false,
        restrictions: {
          maxFileSize: false,
          maxNumberOfFiles: false,
          minNumberOfFiles: false,
          allowedFileTypes: false
        },
      }),
      dashOpts: {
        trigger: '.upload-button',
        proudlyDisplayPoweredByUppy: false,
        inline: false,
        target: '.DashboardContainer',
        replaceTargetContent: true,
        showProgressDetails: true,
        note: 'Please drop files onto this window or click button to browse',
        height: 470,
        metaFields: [
          { id: 'name', name: 'Name', placeholder: 'file name' },
          { id: 'caption', name: 'Caption', placeholder: 'describe what the file is about' }
        ],
        browserBackButtonClose: true
      }
    }
  },
  mounted() {
    this.initUpload()
  },
  methods: {
    onUppyComplete(res) {
      console.log('successful files:', res.successful)
      console.log('failed files:', res.failed)
      this.uppy.reset()
      $(".uppy-Dashboard-close").click()
      this.$parent.setCurrentFolder(this.currentFolderId)
    },
    initUpload() {
      const uppy = this.uppy
        .use(Dashboard, this.dashOpts)
        .use(Tus, {
          endpoint: document.location.origin + "/api/v1/files/",
          resume: true,
          autoRetry: true,
          retryDelays: [0, 1000, 3000, 5000]
        })
      uppy.on('complete', this.onUppyComplete)
    },
    downloadAll() {
      Downloader.downloadWithCallback(`/downloads/all`, {
        selected: this.selectedItems,
        _csrf_token: this.$store.state.csrfToken
      }, {
        contentType: "application/zip",
        fileName: this.downloadFileName
      }, () => {
        $("input:checked").click()
      })
    }
  },
  components: { RightPanelActions }
}
</script>