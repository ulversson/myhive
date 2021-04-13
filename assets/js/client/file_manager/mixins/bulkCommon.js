export default {
	methods: {
		showError() {
      this.$swal('Error', 'You must select at least one item', 'error')
    }
	},
	computed: {
		selectedItems() {
      return this.$store.state.selectedItems
    },
    isSelectedItemsEmpty() {
      return this.selectedItems.length === 0
    }
	}
}