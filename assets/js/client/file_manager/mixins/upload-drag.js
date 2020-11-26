import determineLocation from './determineLocation.js'

export default {
  mixins: [determineLocation],
  computed: {
    existingNames() {
      if (!this.isInArchive && !this.isInShared) {
        return this.$refs.headerPanel.$refs.caseActions.$attrs.assets.map(a => a.name)
      } else {
        return this.assets.map(a => a.name)
      }
    },
    uppyInstance() {
      if (this.uppy) return this.uppy;
      return this.$refs.headerPanel.$refs.caseActions.uppy
    }
  },
  methods: {
    fileAlreadyExists(file) {
      return this.existingNames.filter(i => i === file.name).length > 0
    },
    showExistingFileDialog(file) {
      let vm = this
      this.$swal({
        title: 'File exists',
        html: `The file: <strong>${file.name}</strong> already exists in this directory. Would you like to overwrite?`,
        icon: 'question',
        showCancelButton: true,
        cancelButtonText: "No",
        confirmButtonText: 'Yes!'
      }).then((result) => {
        if (result.value) {
          vm.addFileToUppy(file, true)
          vm.uppyInstance.getPlugin('Dashboard').openModal()
        }
      })
    },
    addFileToUppy(f, overwrite = false) {
      this.files.push(f)
      let uppyFile = {
        name: f.name,
        type: f.type,
        data: f
      }
      if (overwrite)  uppyFile.data.overwrite = overwrite
      this.uppyInstance.addFile(uppyFile)
    },
    addFile(e) {
      if (this.uppyInstance) this.uppyInstance.reset()
      let droppedFiles = e.dataTransfer.files
      if(!droppedFiles) return
      ([...droppedFiles]).forEach(f => {
        if (this.fileAlreadyExists(f)) {
          this.showExistingFileDialog(f)
        } else {
          this.addFileToUppy(f)
          this.uppyInstance.getPlugin('Dashboard').openModal()
        }
      })
    }
  }
}