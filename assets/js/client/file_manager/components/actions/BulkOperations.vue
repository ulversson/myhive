<template>
  <div class="dropdown cui-github-explore-sort-option">
      <button type="button"
        class="btn btn-sm dropdown-toggle"
        data-toggle="dropdown"
        aria-expanded="false">
        Bulk
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <a class="dropdown-item" href="javascript: void(0)"
          @click="markAsNewForAll()" v-if="isAdmin">
          <i class='icmn-eye-minus'></i>&nbsp;Mark as new for all
        </a>
        <a class="dropdown-item" href="javascript: void(0)"
          @click="markSelectedAsViewed()">
          <i class='icmn-eye-plus'></i>&nbsp;Mark as viewed
        </a>
        <div class="dropdown-divider" 
          v-if="!isInArchive && !isInShared"></div>
        <a class="dropdown-item" href="javascript: void(0)" 
          @click="promptTidyUp()"
          v-if="!isInArchive && !isInShared">
          <i class='fas fa-broom'></i>&nbsp;Tidy up folders
        </a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="javascript: void(0)" 
          @click="removeSelectedItems()">
          <i class='fa fa-trash'></i>&nbsp;Remove selected
        </a>
      </ul>
  </div>
</template>
<script>
import { mapState } from 'vuex'
import currentFolder from '../../mixins/currentFolder'
import shared from '../../../medico_legal_cases/mixins/shared'
export default {
  mixins: [ currentFolder, shared ],
  props: ['currentFolder'],
  methods: {
    markAsNewForAll() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.promptMarking('new')
      }
    },
    markSelectedAsViewed() {
      if (this.isSelectedItemsEmpty) {
        this.showError()
      } else {
        this.promptMarking('viewed')
      }
    },
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
    promptTidyUp() {
      this.$swal({
        title: `Tidy up empty folders?`,
        text: "All empty folders without files will be removed in this case",
        icon: 'warning',
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.tidyUpRequest()
      })
    },
    promptMarking(marking) {
       this.$swal({
        title: `Mark selected items as ${marking}?`,
        icon: 'warning',
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.performMarkingAction(marking)
      })
    },
    performMarkingAction(marking) {
      $.ajax({
        type: "PATCH",
        data: { selected: [...new Set(this.selectedItems)], marking: marking },
        url: `/api/v1/bulk_operation/mark_all`
      }).done((r) => {
        if (this.isInArchive) {
          this.$nextTick(() => {
            this.$root.$children[0]
            .setCurrentFolder(this.currentFolder.id)
          })
        } else if (this.isInShared) {
          this.$nextTick(() => {
            this.$root.$children[0]
                        .setCurrentFolder(this.currentFolder.id)

          })
        } else {
          this.refresh()
        }
      })
    },
    tidyUpRequest() {
      $.ajax({
        type: "DELETE",
        data: { selected: [...new Set(this.selectedItems)] },
        url: `/api/v1/bulk_operation/tidy_up?id=${this.currentMedicoLegalCaseId}`
      }).done((r) => {
        window.location.reload(true)
      })
    },
    performDeleteAction() {
      $.ajax({
        type: "DELETE",
        data: { selected: [...new Set(this.selectedItems)] },
        url: `/api/v1/bulk_operation/delete_all`
      }).done((r) => {
        this.refresh()
      })
    }
  },
  computed: {
    ...mapState(['currentMedicoLegalCaseId']),
    isInArchive() {
      let archiveMatch = window.location.pathname.match("/archive")
      return archiveMatch && archiveMatch.length > 0
    },
    isInShared() {
      let sharedMatch = window.location.pathname.match("/shared")
      return sharedMatch && sharedMatch.length > 0
    },
    selectedItems() {
      return this.$store.state.selectedItems
    },
    isSelectedItemsEmpty() {
      return this.$store.state.selectedItems.length === 0
    }
  }
}
</script>