export default {
  created() {
    this.onDirectoryChecked()
    this.onAssetChecked()
  },
  methods: {
    onDirectoryChecked() {
      this.$on('checked.folder', (data) => {
        if (data.checked) {
          this.addSelectedItem(data)
        } else {
          this.removeItemFromSelected(data)
        }
      })
    },
    onAssetChecked() {
      this.$on('checked.asset', (data) => {
        if (data.checked) {
          this.addSelectedItem(data)
        } else {
          this.removeItemFromSelected(data)
        }
      })
    },  
    addSelectedItem(data) {
      this.$store.commit('addSelectedItem', data)
    },
    removeItemFromSelected(data) {
      this.$store.commit('removeSelectedItem', data)
    },
    emitDirectoryChecked(evt, elementId, elemetType) {
      let isChecked = $(evt.target).prop('checked')
      if (this.managerComponent === undefined) {
        this.$emit('checked.folder', {
            checked: isChecked,
            type: elemetType,
            id: elementId
          })
      } else {
        this.managerComponent.$emit('checked.folder', {
          checked: isChecked,
          type: elemetType,
          id: elementId
        })
      }
    }
  }
}