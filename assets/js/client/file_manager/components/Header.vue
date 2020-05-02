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
        <button class="cui-github-explore-sort-option btn btn-default btn-sm">
          <i class='icmn-download'></i>&nbsp;
          Download
        </button>
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        :currentFolder="currentFolder" />
    </div>  
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
import currentFolder from '../mixins/currentFolder'
import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload'
import Dashboard from '@uppy/dashboard'
import Tus from '@uppy/tus'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder],
  data() {
    let vm = this
    return {
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
      }
  },
  components: { RightPanelActions }
}
</script>