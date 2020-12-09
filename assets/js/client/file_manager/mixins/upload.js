import XhrUpload from '@uppy/xhr-upload'
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
import finalizeReport from './finalizeReport'
export default {
  mixins: [finalizeReport],
  props: {
    uploadButton: {
      type: String,
      default: '.upload-button'
    },
    target: {
      type: String,
      default: '.DashboardContainer'

    }
  },
  mounted() {
    this.initUpload()
  },
  computed: {
    uploadHost() {
      return `${window.location.origin}/upload/new`
    },
    uppyInstance() {
      if (this.uppy) return this.uppy;
      return this.$refs.headerPanel.$refs.caseActions.uppy
    }
  },
  methods: {
    successfulExts(collection) {
      return collection.map((i) => i.extension)
    },
    onUppyComplete(res) {
      if (this.uppyInstance) this.uppyInstance.reset()
      $(".uppy-Dashboard-close").click()
      if (this.$parent.isConsultation) {
        debugger
        this.$parent.requestFolder()
      } else {
        this.managerComponent.setCurrentFolder(this.currentFolderId, true)
        let okExt = this.successfulExts(res.successful)
        if ((this.isReportDirectory(this.currentFolder) !== null) && (okExt.includes('pdf') || okExt.includes('doc') || okExt.includes('docx') || okExt.includes('PDF'))) {
          this.finalizeReportPrompt()
        }
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
      uppy.on('file-added', (file) => {
       
      })
    }
  },
  data() {
    let vm = this
    return {
      uppy: Uppy({
        debug: false,
        onBeforeUpload (files) {
          for (const [key, file] of Object.entries(files)) {
            if (file.data.overwrite) {
              if (!file.meta.overwrite) file.meta.overwrite = [""]
              file.meta.overwrite.push(file.name)
            }
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
        trigger: this.uploadButton,
        proudlyDisplayPoweredByUppy: false,
        inline: false,
        target: this.target,
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