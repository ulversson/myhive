<template>
  <div id='medico-legal-cases' class='mt-3 col-md-offset-2 col-md-12'>
    <v-server-table :columns="columns" :options="options"/>
  </div>  
</template>
<script>
import PatientColumn from './PatientColumn.vue'
import UsersColumn from './UsersColumn.vue'
import DateColumn from './DateColumn.vue'
import ActionsColumn from './ActionColumn.vue'
import { Event } from 'vue-tables-2'
export default {
  created() {
    Event.$on('vue-tables.loaded', () => {
      $("[data-toggle='tooltip").tooltip()
    })
  },
  data() {
    return {
      options:  {
        orderBy: {
          column: "id",
          ascending: "false"
        },
        highlightMatches: true,
        requestFunction: function() {
          return $.ajax({
            beforeSend: (request) => { 
              request
                .setRequestHeader("Authorization", 
                  `Bearer ${window.localStorage.getItem('jwt')}`) 
            },
            dataType: 'json',
            data: {query: this.query },
            url: `api/v1/medico_legal_cases?page=${this.page}&limit=${this.options.perPage}&orderBy=${this.orderBy.column}&ascending=${this.orderBy.ascending}&tab=${this.options.params.tab}`
          })
        },
        headings: {
          id: 'ID',
          patient: 'Patient',
          users: 'Users',
          created: 'Created',
          actions: 'Actions'
        },
        filterByColumn: true,
        skin: `table-bordered table table-responsive table-striped table-mlc`,
        sortIcon: {
          base : 'fas',
          is: 'fa-sort',
          up: 'fa-sort-up',
          down: 'fa-sort-down'
        },
        highlightMatches: true,
        perPageValues: [10, 25, 50, 100],
        templates: {
          patient: PatientColumn,
          users: UsersColumn,
          created_at: DateColumn,
          actions: ActionsColumn
        },
        params: {
          tab: this.tab
        },
        columnsClasses: {
          id: 'mlc-id',
          patient: 'mlc-patient',
          users: 'mlc-users',
          created_at: 'mlc-created-at text-secondary'
        },
        perPage: 10,
        requestKeys: { 
          query:'query', 
          limit:'limit', 
          orderBy:'orderBy', 
          ascending:'ascending', 
          page:'page', 
          byColumn:'byColumn' 
        },
        pagination: { dropdown: false },
        editableColumns:['patient'],
        sortable: ['id', 'patient','created_at'],
        filterable: ['id', 'patient', 'users', 'created_at']
      },
      page: 1,
      query: '',
      orderBy: 'id',
      byColumn: 'id',
      count: 0,
      ascending: false,
      columns: [
        'id', 'patient', 'users', 'created_at', 'actions'
      ]
    }
  },
  props: ['tab']
}
</script>