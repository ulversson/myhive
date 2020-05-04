<template>
  <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <button class="btn-floating btn-sml text-default btn-rounded" type="button" id="dropdownMenu3" 
      data-toggle="dropdown"
      style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
      <i class="fas fa-ellipsis-h"></i>
    </button>
    <div class="dropdown-menu dropdown-primary">
      <a class="dropdown-item" href="#" @click="downloadDirectory()">
        <i class="icmn-download"></i>&nbsp;Download
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-pen"></i>&nbsp;Rename
      </a>
      <a class="dropdown-item" href="#" @click="removeDirectory()">
        <i class="fas fa-trash"></i>&nbsp;Remove
      </a>
    </div>
  </td>
</template>
<script>
import Downloader from '../../../../ajax-downloader'
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['directory', 'currentFolder'],
  mixins: [currentFolder],
  methods: {
    removeDirectory() {
      this.$swal({
        html: `Directory: <strong>${this.directory.name}</strong> will be irreversibly deleted`,
        icon: 'warning',
        title: 'Remove directory?',
        focusConfirm: false,
        showCancelButton: true
      }).then((result) => {
        if (result.value) this.performDeleteAction()
      })
    },
    performDeleteAction(){
     $.ajax({
        type: "DELETE",
        data: { id: this.directory.id },
        url: `/api/v1/folders/${this.directory.id}`
      }).done((r) => {
        this.refresh()
      })
    },
    downloadDirectory() {
      Downloader.downloadWithCallback(`/api/v1/folders/download`, {
        selected: [{"id": this.directory.id, type: "folder"}],
        _csrf_token: this.$store.state.csrfToken
      }, {
        contentType: "application/zip",
        fileName: `${this.directory.name}.zip`
      }, () => {
        $("input:checked").click()
      })
    }
  }
}
</script>