export default {
  computed: {
    managerComponent() {
      return this.$root.$children[0]
    },
    hasParent() {
      return this.currentFolder && this.currentFolder.parent_id
    },
    consultationComponent() {
      if (this.$parent && this.$parent.$parent && this.$parent.$parent.isConsultation) return this.$parent.$parent
    }
  },
  methods: {
    loadParent() {
      this.managerComponent.setCurrentFolder(this.currentFolder.parent_id)
    },
    openFolder(folderId) {
      this.managerComponent.setCurrentFolder(folderId)
      if (this.managerComponent.currentFolder.parent_id === null) {
        this.managerComponent.setCurrentTab(folderId)
      } else {
        let ancestors = this.managerComponent.currentFolder.ancestors
        if (this.managerComponent.currentFolder && ancestors && ancestors[1]) {
          this.managerComponent.setCurrentTab(ancestors[1])
        }
      }
    },
    refresh() {
      if (this.consultationComponent) {
        this.consultationComponent.requestFolder()
      } else {
        this.managerComponent.setCurrentFolder(this.currentFolder.id)
      }
    }
  }
}