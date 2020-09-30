<template>
  <div class='actions'>
    <Move :directory="directory" 
      :currentFolder="currentFolder"/>
    <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
      <button class="btn-floating btn-sml text-default btn-rounded btn-menu" type="button"
        data-toggle="dropdown"
        style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
        <i class="fas fa-ellipsis-h"></i>
      </button>
      <div class="dropdown-menu dropdown-primary">
        <a class="dropdown-item" href="#" @click="downloadDirectory()">
          <i class="icmn-download"></i>&nbsp;Download
        </a>
        <a class="dropdown-item" href="#" @click="promptUpdateDirectory()"
        v-if="isAdmin || isArchiver">
          <i class="fas fa-pen"></i>&nbsp;Rename
        </a>
        <a @click="moveFolder()" class="dropdown-item">
          <i class="fas fa-truck"></i>
          &nbsp;Move
        </a>
        <a class="dropdown-item" href="#" @click="removeDirectory()"
        v-if="isAdmin || isArchiver">
          <i class="fas fa-trash"></i>&nbsp;Remove
        </a>
      </div>
    </td>
  </div>
</template>
<script>
import Move from './Move.vue'
import Downloader from '../../../../ajax-downloader'
import currentFolder from '../../mixins/currentFolder'
import nameFilter from '../../mixins/nameFilter'
import shared from '../../../medico_legal_cases/mixins/shared'
import Swal from 'sweetalert2'
export default {
  components: { Move },
  props: ['directory', 'currentFolder'],
  mixins: [currentFolder, nameFilter, shared],
  data() {
    return {
      renameName: this.directory.name,
      renameCaption: this.directory.description || ""
    }
  },
  computed: {
    renameFieldsHtml() {
      return `<input id="folder_name" class="swal2-input" placeholder="Enter directory name" name="folder[name]" value="${this.renameName}">` +
      `<textarea id="folder_description" placeholder="Enter optional short description here" class="swal2-textarea" rows="2">${this.renameCaption}</textarea>`
    },
    updateFormData() {
      return {
        "_method": "patch",
        folder: {
          name: this.filterExcludedChars(this.renameName),
          description: this.renameCaption,
          id: this.directory.id
        }
      }
    }
  },
  methods: {
    updateDirectory() {
      $.ajax({
        type: "PATCH",
        url: `/api/v1/folders/${this.directory.id}`,
        data: this.updateFormData
      }).then((r) => {
        this.directory.description = this.renameCaption
        this.directory.name = this.renameName
        this.refresh()
      })
    },
    moveFolder() {
      this.$modal.show(`move-modal-${this.directory.id}`)
    },
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
    },
     promptUpdateDirectory() {
      this.$swal({
        title: 'Please enter new name below',
        html: this.renameFieldsHtml,
        focusConfirm: false,
        showCancelButton: true,
        preConfirm: () => {
          let fieldNameValue = $("input#folder_name").val()
          let fieldCaptionValue = $("textarea#folder_description").val()
          if (fieldNameValue === '') {
            Swal.showValidationMessage(`Name field cannot be empty`)
          }
        return {name: fieldNameValue, caption: fieldCaptionValue}
        }
      }).then((result) => {
        this.renameCaption = result.value.caption
        this.renameName = result.value.name
        this.updateDirectory()
      })    
    }
  }
}
</script>
<style>
.btn-menu {
  border: none;
}
</style>