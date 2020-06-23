<template>
<div class='delete-button'>
  <button type="button" class="btn icon-btn btn-sm btn-outline-danger btn-rounded" 
    @click='deleteRow()'>
    <span class="fa fa-trash-alt"></span>
  </button>
</div>
</template>
<script>
export default {
  methods: {
    deleteRow() {
      let tracking  = this.$root.$children[0].$refs.tracking
      debugger
      let itemId = this.$attrs.data.id
       let deleteData = {
        "_method" : "DELETE",
        "id" : itemId
      }
      this.$swal({
        title: 'Are you sure?',
        text: 'Item will be deleted',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, remove it!',
        position: 'top',
        heightAuto: false, 
        customClass: 'sweetalert-lg',
        width: 550,
        target: document.querySelector('table'),
        cancelButtonText: 'No, keep it'
      }).then((result) => {
        debugger
        if (result.value) {
          $.ajax({
            type: "DELETE",
            url: `/api/vue/tracked_tasks/${itemId}`,
            data: deleteData,
            dataType: "json"
          }).done((resp) => {
            debugger
            tracking.medicoLegalCases = []
            tracking.loadCaseData(tracking.medicoLegalCaseId)
          }).fail(function(err) {
            alert(err.message)
          })
        }
      })
    }
  }
}
</script>