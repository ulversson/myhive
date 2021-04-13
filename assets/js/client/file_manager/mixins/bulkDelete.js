import bulkCommon from './bulkCommon'
export default {
	mixins: [bulkCommon],
	methods: {
		performDeleteAction() {
      $.ajax({
        type: "DELETE",
        data: { selected: [...new Set(this.selectedItems)] },
        url: `/api/v1/bulk_operation/delete_all`
      }).done((r) => {
        this.refresh()
      })
    },
		promptDeletion() {
      this.$swal({
        title: 'Remove selected items?',
        icon: 'warning',
        html: 'Items will be moved to the system bin',
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.performDeleteAction()
      })
    },
		removeSelectedItems() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.promptDeletion()
      }
    }
	}
}