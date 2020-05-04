<template>
  <div class="dropdown cui-github-explore-sort-option">
      <button type="button"
        class="btn btn-sm dropdown-toggle"
        data-toggle="dropdown"
        aria-expanded="false">
        Bulk
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <a class="dropdown-item" href="javascript: void(0)">
          <i class='icmn-eye-minus'></i>&nbsp;Mark as new
        </a>
        <a class="dropdown-item" href="javascript: void(0)">
          <i class='icmn-eye-plus'></i>&nbsp;Mark as read
        </a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="javascript: void(0)" @click="removeSelectedItems()">
          <i class='fa fa-trash'></i>&nbsp;Remove selected
        </a>
      </ul>
  </div>
</template>
<script>
import currentFolder from '../../mixins/currentFolder'
export default {
  mixins: [ currentFolder ],
  props: ['currentFolder'],
  methods: {
    showError() {
      this.$swal('Error', 'You must select at least one item', 'error')
    },
    removeSelectedItems() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.promptDeletion()
      }
    },
    promptDeletion() {
      this.$swal({
        title: 'Remove selected items?',
        icon: 'warning',
        html: 'You won\'t be able to restore them',
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.performDeleteAction()
      })
    },
    performDeleteAction() {
      $.ajax({
        type: "DELETE",
        data: { selected: this.selectedItems },
        url: `/api/v1/bulk_operation/delete_all`
      }).done((r) => {
        this.refresh()
      })
    }
  },
  computed: {
    selectedItems() {
      return this.$store.state.selectedItems
    },
    isSelectedItemsEmpty() {
      return this.$store.state.selectedItems.length === 0
    }
  }
}
</script>