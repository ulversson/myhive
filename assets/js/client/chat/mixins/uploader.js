import Uppy from '@uppy/core'
import FileInput from '@uppy/file-input'
import ProgressBar from '@uppy/progress-bar'
import Tus from '@uppy/tus'
export default {
  data() {
    let vm = this
    return {
      lastAttachment: null,
      uploader: new Uppy({ 
        debug: true, 
        limit: 1,
        autoProceed: true,
        onBeforeUpload (files) {
          for (const [key, file] of Object.entries(files)) {
            if (!file.meta.conversation_id) {
              file.meta.conversation_id = vm.conversation.id
            }
            if (!file.meta.user_id) {
              file.meta.user_id = vm.senderId
            }
          }
        }, 
      })
    }
  }, 
  computed: {
    endpoint() {
      return `${document.location.origin}/api/v1/chat_files/`
    },
    attachmentDownloadUrl() {
      return `/api/v1/chat/${this.conversation.id}/attachments?user_id=${this.senderId}`
    }
  },
  mounted() {
    this.setupUploader()
  },
  methods: {
    onUploadSuccess() {
      $.getJSON(this.attachmentDownloadUrl, (jsonRes) => {
        this.lastAttachment = jsonRes.data
      })
    },
    attach() {
      $("input.uppy-FileInput-input").click()
    },
    setupUploader() {
      this.uploader.use(FileInput, { 
        target: '.chat-form', 
        replaceTargetContent: true,
        pretty: true
      }).use(Tus, { 
        endpoint: this.endpoint,
        retryDelays: [0, 1000, 3000, 5000]
      })
        .use(ProgressBar, { target: '.uprogress', hideAfterFinish: true })
      this.uploader.on('complete', this.onUploadSuccess)
    }
  }
}