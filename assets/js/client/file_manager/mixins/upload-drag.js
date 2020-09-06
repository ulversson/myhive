export default {
  computed: {
    existingNames() {
      return this.$root.$children[0]
        .$refs.headerPanel.$attrs.assets.map(a => a.name)
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
        text: `The file: ${file.name} already exists in this directory. Would you like to overwrite?`,
        icon: 'question',
        showCancelButton: true,
        cancelButtonText: "No",
        confirmButtonText: 'Yes!'
      }).then((result) => {
        if (result.value) {
          vm.addFileToUppy(file, true)
          $("button.upload-button").click()
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
      if (overwrite) 
        uppyFile.data.overwrite = overwrite
      this.uppy.addFile(uppyFile)
    },
    addFile(e) {
      this.uppy.reset()
      let droppedFiles = e.dataTransfer.files
      if(!droppedFiles) return
      ([...droppedFiles]).forEach(f => {
        if (this.fileAlreadyExists(f)) {
          this.showExistingFileDialog(f)
        } else {
          this.addFileToUppy(f)
          $("button.upload-button").click()
        }
      })
    }
  }
}