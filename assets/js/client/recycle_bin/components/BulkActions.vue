<template>
  <div class="buttons" style="margin-bottom: -35px">
    <a class="cui-github-explore-sort-option btn text-white"
      :class="restoreButtonClass"
      title="Restore selected"
      data-toggle="tooltip"
      :disabled="isSelectedItemsEmpty"
      :style="
        isSelectedItemsEmpty ? 'cursor: not-allowed;' : 'cursor: normal'
      "
      @click="restoreSelected()">
      <i class="fal fa-redo"></i>&nbsp; Restore selected
    </a>
    <a class="cui-github-explore-sort-option btn text-white"
      title="Remove selected forever"
      :class="removeButtonClass"
      :disabled="isSelectedItemsEmpty"
      :style=" isSelectedItemsEmpty ? 'cursor: not-allowed;' : 'cursor: normal'"
      @click="removeSelected()"
      data-toggle="tooltip">
      <i class="fal fa-trash-alt"></i>&nbsp; Remove selected
    </a>
  </div>
</template>
<script>
import { mapState } from 'vuex'
export default {
  computed: {
    ...mapState(['selectedItems']),
    restoreButtonClass() {
      return this.isSelectedItemsEmpty ? 'btn-default disabled' : 'btn-warning'
    },
    removeButtonClass() {
      return this.isSelectedItemsEmpty ? 'btn-default disabled' : 'btn-danger'
    },
    isSelectedItemsEmpty() {
      return this.$store.state.selectedItems.length === 0
    }
  },
  methods: {
    restoreSelected() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.$swal({
          title: 'Restore selected items?',
          icon: 'warning',
          html: 'Selected items will be moved to its orignal locations - if these locations still exist in the system',
          focusConfirm: false,
          showCancelButton: true
        }).then((result) => {
          if (result.value) this.performGroupRestoreAction()
        })
      }
    },
    performGroupRestoreAction() {
      $.ajax({
        type: "PATCH",
        data: { selected: [...new Set(this.selectedItems)] },
        url: `/api/v1/recycle_bin/group_restore`
      }).done((r) => {
        window.location.reload(true)
      }).fail((e) => {
        this.$swal({
          icon: e.responseJSON.type,
          title: "Error",
          text: e.responseJSON.error.join(",")
        })
        this.$parent.loadBinContent()
        this.clearSelection()
      })
    },
    clearSelection() {
      this.selectedItems.splice(0, this.selectedItems.length)
      $('input:checked').click()
    },
    removeSelected() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.$swal({
          title: 'Remove selected items?',
          icon: 'warning',
          html: 'Selected items will be removed forever from the system. This action cannot be reverted. ',
          focusConfirm: false,
          showCancelButton: true
        }).then((result) => {
          if (result.value) this.performGroupDeleteAction()
        })
      }
    },
    performGroupDeleteAction() {
      $.ajax({
        type: "DELETE",
        data: { selected: [...new Set(this.selectedItems)] },
        url: `/api/v1/recycle_bin/selected`
      }).done((r) => {
        this.$parent.loadBinContent()
        this.clearSelection()
      })
    },
    showError() {
      this.$swal('Error', 'You must select at least one item', 'error')
    },
  }
}
</script>