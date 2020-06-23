export default {
  methods: {
    saveUpdatedRow(row, fieldName) {
      let updateData = {
        "_method" : "PUT",
        "id" : row.id,
        "field": fieldName,
        "value": row[fieldName]
      }
      $.ajax({
        type: "PUT",
        url: `/api/v1/time_sheet/${row.id}`,
        data: updateData,
        dataType: "json"
      })
    }
  }
}