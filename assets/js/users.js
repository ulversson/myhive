
import  { ApiClient } from './client'
import Datatable from './datatables'
const loadUsersDataTable = () => {
    Datatable.initializeWithColumns('usersDT', 'table#users-datatable', [
        { "data": "id", "name": "id", "autoWidth": true, "sortable": true},     
        { "data": "first_name", "name": "first_name", "autoWidth": true, "sortable": true }, 
        { "data": "last_name", "name": "last_name", "autoWidth": true, "sortable": true },    
        { "data": "email", "name": "email", "autoWidth": true, "sortable": true },    
        { "data": "phone_number", "name": "Phone", "autoWidth": true, "sortable": true },        
        { "data": "roles", "name": "roles", "autoWidth": true, "sortable": false,
          "render" : function (data, type, object, meta)  {
             if (data !== undefined) {
              var stringData = ""
              
              return stringData;
             }
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