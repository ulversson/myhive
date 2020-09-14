export default {
  methods: {
    showEditDescription(row) {
      this.row = row
      this.$modal.show('edit-entry-description', {
        row: row
      })
    },
    runUpdateRequest(row, updateData) {
      $.ajax({
        type: "PUT",
        url: `/api/v1/time_sheet/${row.id}`,
        data: updateData,
        dataType: "json"
      })
    },
    saveUpdatedRow(row, fieldName) {
      let updateData = {
        "_method" : "PUT",
        "id" : row.id,
        "field": fieldName,
        "value": row[fieldName]
      }
      this.runUpdateRequest(row, updateData)
    },
    saveDescFromText(row) {
      let updateData = {
        "_method" : "PUT",
        "id" : row.id,
        "field": 'description',
        "value": $(`textarea[data-id='${row.id}']`).val().trim()
      }
      this.runUpdateRequest(row, updateData)
      window.location.reload(true)
    }
  }
}