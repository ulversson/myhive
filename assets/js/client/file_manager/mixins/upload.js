import Tus from '@uppy/tus'
import XhrUpload from '@uppy/xhr-upload'
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'

export default {
  mounted() {
    this.initUpload()
  },
  computed: {
    uploadHost() {
      return `${window.location.origin}/upload/new`
    }
  },
  methods: {
    onUppyComplete(res) {
      console.log('successful files:', res.successful)
      console.log('failed files:', res.failed)
      this.uppy.reset()
      $(".uppy-Dashboard-close").click()
      if (typeof this.$parent.setCurrentFolder === "function") {
        this.$parent.setCurrentFolder(this.currentFolderId)
      } else {
        this.setCurrentFolder(this.currentFolder.id)
      }
    },
    initUpload() {
      const uppy = this.uppy
        .use(Dashboard, this.dashOpts)
        .use(XhrUpload, {
          endpoint: this.uploadHost,
          headers: {
            'authorization': `Bearer ${window.localStorage.getItem('jwt')}`
          }
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
            if (window.location.href.match('folders')) {
              if (!file.meta.medico_legal_case_id) {
                file.meta.medico_legal_case_id = vm.$store.state.currentMedicoLegalCaseId
              }
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