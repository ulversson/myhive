<template>
    <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <button class="btn-menu btn-floating btn-sml text-default btn-rounded" type="button" id="dropdownMenu3" data-toggle="dropdown"
      style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
      <i class="fal fa-ellipsis-h"></i>
    </button>
    <div class="dropdown-menu dropdown-primary">
      <a @click="getItem()" class="dropdown-item">
        <i class="icmn-download"></i>
        &nbsp;Download
      </a>
      <a class="dropdown-item" 
        @click="restore()">
        <i class="fal fa-redo"></i>
        &nbsp;Restore
      </a>
      <a class="dropdown-item" 
        @click="remove()">
        <i class="fal fa-trash"></i>
        &nbsp;Remove forever
      </a>
    </div>
  </td>
</template>
<script>
import selection from '../../file_manager/mixins/selection'
import binDownload from '../mixins/binDownload'
import UI from '../../../ui'
export default {
  props: ['itemType', 'item'],
  mixins: [ selection, binDownload ], 
  computed: {
    restoreUrl() {
      return `/api/v1/recycle_bin/${this.item.id}/${this.itemType}/restore`
    },
    deleteUrl() {
      return `/api/v1/recycle_bin/${this.item.id}/${this.itemType}`
    }
  },
  methods: {
    restore() {
      UI.runConfirmedAction(
        'fas fa-check', 
        'PATCH',
        `Restore ${this.itemType}`,
        'Item will be moved back to its original location',
        this.restoreUrl,
        () =>{
          window.location.reload(true)
        })
    },
    remove() {
      UI.runConfirmedAction(
        'fas fa-trash-alt',
        'DELETE',
        `Remove forever ${this.itemType}`,
        'You will not be able to revert this',
        this.deleteUrl,
        () => {
          window.location.reload(true)
        }
      )
    }
  }
}
</script>