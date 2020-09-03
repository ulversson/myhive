export default {
  methods: {
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
    saveDescFromText(row, text) {
      let updateData = {
        "_method" : "PUT",
        "id" : row.id,
        "field": 'description',
        "value": text
      }
      this.runUpdateRequest(row, updateData)
      window.location.reload(true)
    }
  }
}