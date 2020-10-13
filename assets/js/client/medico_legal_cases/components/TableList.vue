<template>
  <div id='medico-legal-cases' 
    style="padding-left: 0px"
    class='mt-3 col-md-offset-2 col-md-12'>
    <v-server-table 
      :columns="columns" 
      :options="options" 
      :tab="tab"
      ref='tab'/>
  </div>  
</template>
<script>
import PatientColumn from './PatientColumn.vue'
import UsersColumn from './UsersColumn.vue'
import DateColumn from './DateColumn.vue'
import ActionsColumn from './ActionColumn.vue'
import UI from '../../../ui'
import { Event } from 'vue-tables-2'
export default {
  data() {
    return {
      options:  {
        orderBy: {
          column: "id",
          ascending: "false"
        },
         responseAdapter(data) {
          this.$store.commit('setRole', data.role[0])
          return data
        },
        highlightMatches: true,
          requestFunction: function() {
            let jwt = window.localStorage.getItem('jwt')
            let refreshToken = window.localStorage.getItem('refresh')
            return $.ajax({
              beforeSend: (request) => { 
                request
                  .setRequestHeader("Authorization", `Bearer ${jwt}`) 
              },
              dataType: 'json',
              data: {query: this.query },
              url: `api/v1/medico_legal_cases?page=${this.page}&limit=${($(`div#${this.options.params.tab} div.VueTables select:first`).val() || 10)}&orderBy=${this.orderBy.column}&ascending=${this.orderBy.ascending}&tab=${this.options.params.tab}`
            }).catch(function (e) {
              if (refreshToken === null) {
                window.location.reload(true)
              } else {
                $.get(`/token/refresh?jwt_refresh=${refreshToken}`, (res) => {
                  window.localStorage.setItem('jwt', res.jwt)
                  window.localStorage.setItem('refresh', res.refresh)
                  window.location.reload(true)
                })
              }
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
        perPageValues: [],
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
      role: null,
      ascending: false,
      columns: [
        'id', 'patient', 'users', 'created_at', 'actions'
      ]
    }
  },
  props: ['tab']
}
</script>