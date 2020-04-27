export default {
  computed: {
    activeTab() {
      return this.$root.$children[0].$refs.tabs.$data.activeTab
    },
    csrfToken() {
      return document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content")
    },
    folderColor() {
      switch(this.activeTab) {
        case 'pending':
          return 'text-warning'
        case 'current':
          return 'text-success'
        case 'settled':
          return 'text-secondary'
      }
    }
  }
}