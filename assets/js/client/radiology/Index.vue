<template>
  <v-client-table :columns="columns" ref="table"
    v-model="radiology" :options="options">
  </v-client-table>
</template>
<script>
import Vue from 'vue'
import { ClientTable } from 'vue-tables-2'
import DateColumn from './components/DateColumn.vue'
import ModalityColumn from './components/ModalityColumn.vue'
import ActionsColumn from './components/ActionsColumn.vue'
const options =  {
  highlightMatches: true,
  orderBy: { column: "Study Date", ascending: false },
  headings: {
    "Patient ID": 'Patient ID',
    "Ascension Number": 'Ascension Number',
    "Modalities in Study": 'Modality',
    "Study Date": 'Date'
  },
  filterByColumn: false,
  skin: 'table-striped table-bordered table-hover',
  sortIcon: {
    base : 'fas',
    is: 'fa-sort',
    up: 'fa-sort-up',
    down: 'fa-sort-down'
  },
  templates: {
    "Study Date" : DateColumn, 
    "Modalities in Study" : ModalityColumn,
    "Actions": ActionsColumn
  },
  highlightMatches: true,
  perPageValues: [],
  perPage: 100,
  sortable: ['Patient ID', 'Accession Number', 'Modalities in Study', "Study Date"]
}
Vue.use(ClientTable, [options], 
  false, 'bootstrap4', 'default'
);
export default {
  computed: {
    dicomName() {
      return window.location.pathname.split("/")[3]
    }
  },
  mounted() {
    this.$refs.table.setLoadingState(true)
    $.getJSON(`/api/v1/radiology/browse/${this.dicomName}`, (resp) => {
      this.radiology = resp.data
      this.$refs.table.setLoadingState(false)
    })
  },
  components: {  DateColumn, ModalityColumn, ActionsColumn },
  data() {
    return {
      radiology: [],
      columns: [ 'Patient ID', 'Accession Number', 'Modalities in Study', "Study Date", "Actions"],
      options: options
    }
  },
}
</script>
<style type="text/css">
.VueTables--client table{
  width: 100% !important;
}
</style>