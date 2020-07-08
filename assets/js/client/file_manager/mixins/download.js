import Downloader from '../../../ajax-downloader'
export default {
  methods: {
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
  computed: {
    selectedItemClass() {
      return this.selectedItems.length === 0 ? 'btn-default' : 'btn-success'
    },
    downloadFileName() {
      return `archive_${moment().format('LLLL').replace(/,/g,"").replace(/\s/g,"_")}.zip`
    }
  },
  data() {
    return {
      selectedItems : this.$store.state.selectedItems,
    }
  }
}