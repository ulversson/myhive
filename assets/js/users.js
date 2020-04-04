
import Datatable from './datatables'
const loadUsersDataTable = () => {
    Datatable.initializeWithColumns('usersDT', 'table#users-datatable', [
        { "data": "id", "name": "id", "autoWidth": true, "sortable": true},     
        { "data": "first_name", "name": "first_name", "autoWidth": true, "sortable": true }, 
        { "data": "last_name", "name": "last_name", "autoWidth": true, "sortable": true },    
        { "data": "email", "name": "email", "autoWidth": true, "sortable": true },    
        { "data": "phone_number", "name": "Phone", "autoWidth": true, "sortable": true },        
        { "data": "roles", "name": "roles", "autoWidth": true, "sortable": true,
          "render" : function (data, type, object, meta)  {
             if (data !== undefined) {
              let stringData = ""
              stringData = `<span class="badge badge-pill badge-secondary badge-lg font-size-14">${data.join(",")}</span>`
              return stringData;
             }
            }
        },
        { "data": "roles", "name": "roles", "autoWidth": true, "sortable": false,
          "render" : function (data, type, object, meta)  {
            let buttons = `<button data-remote="true" type="button" data-url="/users/${object.id}" class="btn btn-xs btn-outline-info rounded-circle" data-toggle='tooltip' data-title='User details and statistics'><i class='fa fa-eye'></i></button>
              &nbsp;<button type="button" data-remote="true" data-url="/users/${object.id}/edit"  class="btn btn-xs btn-outline-warning rounded-circle" data-toggle='tooltip' data-title='Edit user'><i class='icmn-pencil'></i></button>
              &nbsp;<button type="button" data-remote="true" data-url="/users/${object.id}" data-method="delete" class="btn btn-xs btn-outline-danger rounded-circle" data-toggle='tooltip' data-title='Remove user'><i class='icmn-bin2'></i></button>`
              
            return buttons
          }
        }
      ])
  }

export default {
  loadUsersDataTable,
  init() {
    loadUsersDataTable()
  }
}