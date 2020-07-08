export default {
  methods: {
    addFile(e) {
      let droppedFiles = e.dataTransfer.files
      if(!droppedFiles) return
      ([...droppedFiles]).forEach(f => {
        this.files.push(f)
        let reader = new FileReader()
        this.uppy.addFile({
          name: f.name,
          type: f.type,
          data: f
        })
        $("button.upload-button").click()
      })
    }
  }
}