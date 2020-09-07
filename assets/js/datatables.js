import Swal from 'sweetalert2'
const GLOBAL_PER_PAGE_DATATABLES = 10

const initializeWithColumns = function (referenceName, dataTableId, columns) {
  window[referenceName] = $(dataTableId).DataTable({
    "processing": true,
    "serverSide": true,
    "filter": true,
    "stateSave": true,
    "lengthChange": false,
    "destory": true,
    "responsive": true,
    "orderMulti": false,
    "pageLength": GLOBAL_PER_PAGE_DATATABLES,
    "ajax": {
      "url": $(dataTableId).data("url"),
      "statusCode": {
        401: function (xhr, error, thrown) {
          Swal.fire(
            "Unauthorized",
            "You are not authorized to perform this action!. You will be redirected", 
            "error")
          setTimeout(() => {
            window.location.href= "/"
          }, 2500)
          return false
        },
      },
      "headers": {
        "Authorization": `Bearer ${window.localStorage.getItem('jwt')}`
      },
      "type": "GET",
      "datatype": "json"
    },
    "drawCallback": function() {
      $("[data-toggle=tooltip]").tooltip()
      UI.setupHtmlRemoteDetailsLink()
      UI.confirmDialog(() => {
        window[referenceName].ajax.reload()
      })
    },
    "columns": columns
    })
  }

  export default {
    initializeWithColumns
  }