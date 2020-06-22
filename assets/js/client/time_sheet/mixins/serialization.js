export default {
  methods: {
    serializeAndSaveFormLocal() {
      let form = this.formData().time_entry
      let formJsonString = JSON.stringify(form)
      window.localStorage.setItem(this.formSelector, formJsonString)
      return true
    },
    serializeAndSaveForm() {
      let form = this.$refs.newForm.formData().time_entry
      let formJsonString = JSON.stringify(form)
      window.localStorage.setItem(this.formSelector, formJsonString)
    },
    isFormSerialized() {
      let storage = window.localStorage.getItem(this.formSelector) 
      return storage !== null && storage !== undefined && storage !== ''
    },
    deserializeForm() {
      let formData = window.localStorage.getItem(this.formSelector)
      return JSON.parse(formData)
    },
    clearSavedForm() {
      window.localStorage.removeItem(this.formSelector)
    },
    initialFormVisible(){
      let formStorage =  window.localStorage.getItem(this.formSelector)
      return formStorage !== null && formStorage !== undefined
    },
    timeFromDate(isoDate) {
      if (isoDate === '') return null
      return isoDate.split("T")[1]
        .replace("Z","")
        .substr(0,5)
    }
  },
  computed: {
    formSelector() {
      return 'form#new-entry-form'
    }
  }
}