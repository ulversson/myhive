export default {
  computed: {
    showUserError() {
      if ($(this.selectName).length === 0) return false
      return this.submit && $(this.selectName).length > 0 && $(this.selectName).val().length === 0
    }
  },
  data() {
    return {
      submit: false
    }
  },
  methods: {
    triggerSelect2Change() {
      $(this.selectName).trigger('change')
    },
    selectValues() {
      let selectVal = $(this.selectName).val()
      if (!selectVal) return []
      if (typeof selectVal === "string") return parseInt(selectVal)    
      return selectVal.map((i) => parseInt(i))
    },
    clearSelect2Error() {
      $(this.selectName).parent()
        .removeClass('has-danger')
        .removeClass('is-invalid')
      $(this.selectName).removeClass('is-invalid')
    },
    addSelect2Error() {
      $(this.selectName).parent()
        .addClass('has-danger')
        .addClass('is-invalid')
      $(this.selectName).addClass('is-invalid')
    },
    bindSelect2UserEvents(multiple = true) {
      UI.autocompleteSearch('select#user-search', multiple)
      $(this.selectName).on('select2:select', () => {
        if ($(this.selectName).val().length > 0) {
          this.clearSelect2Error()
        }
      })
       $(this.selectName).on('select2:unselect', () => {
        if ($(this.selectName).val().length === 0) {
          this.addSelect2Error()
        }
      })
    }
  }
}