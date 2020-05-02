import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
import Tus from '@uppy/tus'
export default {
  data() {
    return {
      uppy: Uppy({
        debug: true,
        autoProceed: false,
        restrictions: {
          maxFileSize: 5000000000,
          maxNumberOfFiles: 10,
          minNumberOfFiles: 1,
          allowedFileTypes: ['*/*']
        }
      }),
      dashOpts: {
        trigger: '.upload-button',
        proudlyDisplayPoweredByUppy: false,
        inline: false,
        target: '.DashboardContainer',
        replaceTargetContent: true,
        showProgressDetails: true,
        note: this.note,
        height: 470,
        metaFields: [
          { id: 'name', name: 'Name', placeholder: 'file name' },
          { id: 'caption', name: 'Caption', placeholder: 'describe what the file is about' }
        ],
        browserBackButtonClose: true
      },
      tusOpts: { endpoint: this.uppyEndpoint }
    }
  },
  computed: {
    uppyEndpoint() {
      return 'https://master.tus.io/files/'
    },
    note() {
      return 'Please drop files onto this window or click button to browse'
    }
  },
  methods: {
    onUppyComplete(res) {
      console.log('successful files:', res.successful)
      console.log('failed files:', res.failed)
    },
    initUpload() {
      const uppy = this.uppy
        .use(Dashboard, this.dashOpts)
        .use(Tus, this.tusOpts)
        uppy.on('complete', this.onUppyComplete)
    }
  }
}