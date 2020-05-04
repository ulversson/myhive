<template>
  <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <button class="btn-floating btn-sml text-default btn-rounded" type="button" id="dropdownMenu3" data-toggle="dropdown"
      style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
      <i class="fas fa-ellipsis-h"></i>
    </button>
    <div class="dropdown-menu dropdown-primary">
      <a :href="downloadUrl" class="dropdown-item">
        <i class="icmn-download"></i>
        &nbsp;Download
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-pen"></i>
        &nbsp;Rename
      </a>
      <a class="dropdown-item" href="#" @click="removeFileAsset()">
        <i class="fas fa-trash"></i>
        &nbsp;Remove
      </a>
    </div>
  </td>
</template>
<script>
import currentFolder from '../../mixins/currentFolder'
export default {
  mixins: [currentFolder],
  methods: {
    removeFileAsset() {
      this.$swal({
        title: `Remove file?`,
        icon: 'warning',
        html: `file: <strong>${this.fileAsset.name}</strong> will be irreversibly deleted`,
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.performDeleteAction()
      })
    },
    performDeleteAction(){
     $.ajax({
        type: "DELETE",
        data: { id: this.fileAsset.id },
        url: `/api/v1/file_assets/${this.fileAsset.id}` 
      }).done((r) => {
        debugger
        this.refresh()
      })
    },
  },
  computed: {
    downloadUrl() {
      return `downloads/${this.fileAsset.id}`
    }
  },
  props: ['fileAsset', 'currentFolder']
}
</script>