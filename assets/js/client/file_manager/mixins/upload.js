import Tus from '@uppy/tus'
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'

export default {
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
  data() {
    let vm = this
    return {
      uppy: Uppy({
        debug: false,
        onBeforeUpload (files) {
          for (const [key, file] of Object.entries(files)) {
            if (!file.meta.folder_id) {
              file.meta.folder_id = vm.currentFolderId
            }
            if (!file.meta.user_id) {
              file.meta.user_id = $("div.cui-topbar-avatar-dropdown").data().userId
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
  }
}