<template>
  <a class="btn btn-danger btn-tooltip"
    @click="promptNewFolder('Folder name')"
    data-toggle="tooltip"
    style='margin-right: 6.89px'
    data-title="Add new folder in currently opened directory">
    <i class="fas fa-folder-plus"></i>
    &nbsp;Add new
  </a>
</template>
<script>
import Swal from 'sweetalert2'
import currentFolder from '../../mixins/currentFolder'
import nameFilter from '../../mixins/nameFilter'
export default {
  props: ['currentFolder'],
  mixins: [currentFolder, nameFilter],
  data(){
    return {
      folderName: "",
      folderDescription: ""
    }
  },
  computed: {
    promptFieldsHtml() {
      return '<input id="folder_name" class="swal2-input" placeholder="Enter folder name" name="folder[name]">' +
      '<textarea id="folder_description" placeholder="Optional short description" class="swal2-textarea" rows="2"></textarea>'
    },
    folderType() {
      if (window.location.href.match("/folders")) {
        return "medico_legal_case"
      } else if (window.location.href.match("/archive")) {
        return "archive"
      } else if (window.location.href.match("/shared/view")) {
        return "shared_folder"
      }
    },
    formData() {
      return  {
        name: this.filterExcludedChars(this.folderName),
        description: this.folderDescription,
        parent_id: this.currentFolder.id,
        folder_type: this.folderType,
        order: this.$store.state.order,
        column: this.$store.state.column
      }
    }
  },
  methods: {
    formFolderName() {
      return Swal.getPopup().querySelector('#folder_name').value
    },
    formFolderDesc() {
      return Swal.getPopup().querySelector('#folder_description').value
    },
    promptNewFolder(title) {
     this.$swal({
      title: title,
      html: this.promptFieldsHtml,
      focusConfirm: false,
      showCancelButton: true,
      preConfirm: () => {
        if (this.formFolderName() === '') {
          Swal.showValidationMessage(`Name field cannot be empty`)
        }
        return {name: this.formFolderName(), folderDescription: this.formFolderDesc()}
      }
    }).then((result) => {
      this.folderDescription = result.value.folderDescription
      this.folderName = result.value.name
      this.saveNewFolder()
    })    
  },
  saveNewFolder() {
    $.ajax({
        type: "POST",
        url: `/api/v1/folders`,
        data: this.formData
      }).then((r) => this.openFolder(r.parent_id) )
    }
  }
}
</script>