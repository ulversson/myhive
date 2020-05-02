export default {
  computed: {
    managerComponent() {
      return this.$root.$children[0]
    },
    hasParent() {
      return this.currentFolder && this.currentFolder.parent_id
    }
  },
  methods: {
    loadParent() {
      this.managerComponent.setCurrentFolder(this.currentFolder.parent_id)
    },
    openFolder(folderId) {
      this.managerComponent.setCurrentFolder(folderId)
    },
    refresh() {
      this.managerComponent.setCurrentFolder(this.currentFolder.id)
    }
  }
}