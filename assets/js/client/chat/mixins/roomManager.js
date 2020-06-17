export default {
  computed: {
    showUserError() {
      return this.submit && $("select#user-search").val().length === 0
    }
  },
  data() {
    return {
      submit: false
    }
  },
  methods: {
    triggerSelect2Change() {
      $('select#user-search').val('').trigger('change')
    },
    selectValues() {
      return $("select#user-search").val()
        .map((i) => parseInt(i))
    },
    clearSelect2Error() {
      $("select#user-search").parent().removeClass('has-danger')
    },
    addSelect2Error() {
      $("select#user-search").parent().addClass('has-danger')
    },
    bindSelect2UserEvents() {
      UI.autocompleteSearch('select#user-search', true)
      $("select#user-search").on('select2:select', () => {
        if ($("select#user-search").val().length > 0) {
          this.clearSelect2Error()
        }
      })
       $("select#user-search").on('select2:unselect', () => {
        if ($("select#user-search").val().length === 0) {
          this.addSelect2Error()
        }
      })
    }
  }
}