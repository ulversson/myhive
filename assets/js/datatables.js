
const initializeWithColumns = function (referenceName, dataTableId, columns) {
  window[referenceName] = $(dataTableId).DataTable({
    "processing": true,
    "serverSide": true,
    "filter": true,
    "destory": true,
    "responsive": true,
    "orderMulti": false,
    "pageLength": 100,
    "order": [[0, "desc"]],
    "ajax": {
      "url": $(dataTableId).data("url"),
      "headers": {
        "Authorization": `Bearer ${window.localStorage.getItem('jwt')}`
      },
      "type": "GET",
      "datatype": "json"
    },
    "drawCallback": function() {
    },
    "columns": columns
    })
  }

  export default {
    initializeWithColumns
  }