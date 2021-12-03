<template>
  <div class='my-hive-radiology'>
    <button class="btn btn btn-myhive btn-radiology active mt-3 float-right" 
      :class="checkedRows.length === 0 ? 'disabled' : ''"
      title="Load selected radiology items in the Desktop browser"
      data-toggle="tooltip"
      @click="browseSelected"
      :disabled="checkedRows.length === 0"
      id='view selected radiology'>
      <i class="far fa-x-ray"></i>
      &nbsp;<span class='font-size-14 text'>Browse selected radiology</span>
    </button>
    <v-client-table :columns="columns" ref="table"
      v-model="radiology" :options="options">
        <template slot="h__selected">
          <label class="cui-utils-control cui-utils-control-checkbox ml-4">
            <input type="checkbox" id="checkbox"  
              @click="selectAllAtOnce()">
            <span class="cui-utils-control-indicator"></span>
          </label>
        </template>
        <label class="cui-utils-control cui-utils-control-checkbox ml-4" slot="selected" slot-scope="props">
          <input type="checkbox" v-model="checkedRows" :checked="props.row.selected" 
            :value="props.row['Study Instance UID']">
            <span class="cui-utils-control-indicator"></span>
        </label>
    </v-client-table>
  </div>
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
  methods: {
    selectAllAtOnce(){
    const length = this.$refs.table.data.length
    this.isSelected = !this.isSelected

    for (let i = 0; i < length; i++) {
      let item = this.$refs.table.data[i]
      item.selected = this.isSelected
      if (this.isSelected) {
        this.checkedRows.push(item['Study Instance UID'])
      } else {
        let idx = this.checkedRows.indexOf(item['Study Instance UID'])
        this.checkedRows.splice(idx, 1)
      }
    }
    },
    browseSelected() {
      window.open(this.viewStudyLink)
    }
  },
  computed: {
    dicomName() {
      return window.location.pathname.split("/")[3]
    },
    viewStudyLink() {
      const studies = this.checkedRows.map(s => ` -r "studyUID=${s}" `)
      return "weasis://"+encodeURIComponent(`$dicom:rs --url "${this.browserLink}" ${studies} -H "Authorization: Basic ZGljb21hZG1pbjozNDVkYWFjZDhiZTM="`)
    },
    browserLink() {
      return "https://dicom.my-hive.co.uk/orthanc/dicom-web" 
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
      isSelected: false,
      checkedRows: [],
      radiology: [],
      columns: ['selected', 'Patient ID', 'Accession Number', 'Modalities in Study', "Study Date", "Actions"],
      options: options
    }
  },
}
</script>
<style type="text/css">
.VueTables--client table{
  width: 100% !important;
}
button.btn-radiology.disabled {
  opacity: 0.5;
}
</style>