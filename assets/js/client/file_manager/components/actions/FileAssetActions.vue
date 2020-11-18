<template>
  <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <button class="btn-menu btn-floating btn-sml text-default btn-rounded" type="button" id="dropdownMenu3" data-toggle="dropdown"
      style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
      <i class="fas fa-ellipsis-h"></i>
    </button>
    <div class="dropdown-menu dropdown-primary">
      <pdf :asset="fileAsset" v-if="fileExt === 'pdf'" />
      <a :href="downloadUrl" class="dropdown-item">
        <i class="icmn-download"></i>
        &nbsp;Download
      </a>
      <a class="dropdown-item" href="#" @click="promptUpdateAsset()"
        v-if="isAdmin || isArchiver">
        <i class="fas fa-pen"></i>
        &nbsp;Rename
      </a>
      <a class="dropdown-item" href="#" data-toggle="tooltip"
        data-title="Change file timestamp" @click="changeTimeStamp()">
        <i class="far fa-clock"></i>
        &nbsp;Timestamp
      </a>
      <a @click="moveFile()" class="dropdown-item">
        <i class="fas fa-truck"></i>
        &nbsp;Move
      </a>
      <a class="dropdown-item" href="#" @click="removeFileAsset()"
        v-if="isAdmin || isArchiver">
        <i class="fas fa-trash"></i>&nbsp;Remove
      </a>
    </div>
  </td>
</template>
<script>
import currentFolder from '../../mixins/currentFolder'
import nameFilter from '../../mixins/nameFilter'
import shared from '../../../medico_legal_cases/mixins/shared'
import pdf from './by_extension/pdf.vue'
import Swal from 'sweetalert2'
export default {
  mixins: [currentFolder, nameFilter, shared],
  components: { pdf  },
  data() {
    return {
      renameName: this.fileAsset.name,
      renameCaption: this.fileAsset.caption || ""
    }
  },
  methods: {
    changeTimeStamp(){
      this.$parent.$modal.show(`change-timestamp-${this.fileAsset.id}`)
    },
    updateFileAsset() {
      $.ajax({
        type: "PATCH",
        url: `/api/v1/file_assets/${this.fileAsset.id}`,
        data: this.updateFormData
      }).then((r) => {
        this.fileAsset.caption = this.renameCaption
        this.fileAsset.name = this.renameName
        this.refresh()
      })
    },
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
        this.refresh()
      })
    },
    promptUpdateAsset() {
      this.$swal({
        title: 'Please enter new name below',
        html: this.renameFieldsHtml,
        focusConfirm: false,
        showCancelButton: true,
        preConfirm: () => {
          let fieldNameValue = $("input#file_asset_name").val()
          let fieldCaptionValue = $("textarea#file_asset_description").val()
          if (fieldNameValue === '') {
            Swal.showValidationMessage(`Name field cannot be empty`)
          } else if (this.doesNotHaveDot(fieldNameValue)) {
            Swal.showValidationMessage(`File name must have an extension ie: pdf, doc, zip`)
          }
        return {name: fieldNameValue, caption: fieldCaptionValue}
        }
      }).then((result) => {
        this.renameCaption = result.value.caption
        this.renameName = result.value.name
        this.updateFileAsset()
      })    
    },
    moveFile() {
      this.$modal.show(`move-modal-${this.fileAsset.id}`)
    }
  },
  computed: {
    fileExt() {
      return this.fileAsset.name.split(".").pop()
    },
    downloadUrl() {
      return `/downloads/${this.fileAsset.id}`
    },
    renameFieldsHtml() {
      return `<input id="file_asset_name" class="swal2-input" placeholder="Enter file name" name="file_asset[name]" value="${this.renameName}">` +
      `<textarea id="file_asset_description" placeholder="Enter optional short description here" class="swal2-textarea" rows="2">${this.renameCaption}</textarea>`
    },
    timestampChangeHtml() {
      return `<input id="file_asset_date" class="swal2-input" placeholder="Pick new timestap" name="file_asset[name]" value="${moment(this.fileAsset.updated_at).format('DD/MM/YYYY HH:MM')}">`;
    },
    updateFormData() {
      return {
        "_method": "patch",
        file_asset: {
          name: this.filterExcludedChars(this.renameName),
          caption: this.renameCaption,
          id: this.fileAsset.id
        }
      }
    }
  },
  props: ['fileAsset', 'currentFolder']
}
</script>
<style>
.btn-menu {
  border: none;
}
</style>