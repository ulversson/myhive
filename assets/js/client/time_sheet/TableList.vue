<template>
  <div id='time-sheet-entries' 
    class='mt-3 col-md-offset-2 col-md-12'>
    <h4>Total time: {{ totalTime }}&nbsp;(h:m)</h4>
    <v-server-table 
      :columns="columns" 
      :options="options" 
      ref='time-sheet'>
      <div slot="description" slot-scope="{row, update, setEditing, isEditing, revertValue}">
        <span @click="setEditing(true)" v-if="!isEditing()">
          <a style='color: #08f !important'
            class='inline-edit cui-utils-link-underlined cui-utils-link-blue'>
            {{row.description}}
          </a>
        </span>
        <span v-else>
          <textarea type="text" v-model="row.description"  class='form-control' rows='2'></textarea>
          <a class='text-white btn-sm btn-primary' @click="update(row.description); saveUpdatedRow(row, 'description');setEditing(false)">
            SAVE
          </a>
          <a class='text-white btn-sm btn-secondary' @click="revertValue(); setEditing(false)">
            Cancel
          </a>        
        </span>  
      </div>
      <div slot="note" slot-scope="{row, update, setEditing, isEditing, revertValue}">
        <span @click="setEditing(true)" v-if="!isEditing()">
          <a style='color: #08f !important'
            class='inline-edit cui-utils-link-underlined cui-utils-link-blue'>
            {{row.note}}
          </a>
          <a style='color: #08f !important'
            class='inline-edit text-white btn-sm btn-default' v-if='row.note === "" || row.note === null'>EDIT</a>
        </span>
        <span v-else>
          <textarea type="text" v-model="row.note"  class='form-control' rows='2'></textarea>
          <a class='text-white btn-sm btn-primary' @click="update(row.note); saveUpdatedRow(row, 'note');setEditing(false)">
            SAVE
          </a>
          <a class='text-white btn-sm btn-secondary' @click="revertValue(); setEditing(false)">
            Cancel
          </a>        
        </span>  
      </div>
    </v-server-table>
  </div>  
</template>
<script>
import StartDateColumn from './columns/StartDateColumn.vue'
import EndDateColumn from './columns/EndDateColumn.vue'
import DurationColumn from './columns/DurationColumn.vue'
import FeeColumn from './columns/FeeColumn.vue'
import DeleteColumn from './columns/DeleteColumn.vue'
import timeSheetUpdate from './mixins/timeSheetUpdate'
import { Event } from 'vue-tables-2'
export default {
  mixins: [timeSheetUpdate],
  props: ['medicoLegalCaseId'],
  components: { 
    StartDateColumn, 
    EndDateColumn,
    DurationColumn,
    FeeColumn
  },
  created() {
    Event.$on('vue-tables.loaded', () => {
      this.$parent.$emit('ids', this.tableIds)
    })
  },
  data() {
    return {
      totalTime: window.localStorage.getItem('totalTime'),
      options:  {
        orderBy: {
          column: "id",
          ascending: "false"
        },
        highlightMatches: true,
        templates: {
          start_date: StartDateColumn,
          end_date: EndDateColumn,
          duration: DurationColumn,
          fee: FeeColumn,
          delete: DeleteColumn
        },
        requestFunction: function() {
          let vm = this
          return $.ajax({
            beforeSend: (request) => { 
              request
                .setRequestHeader("Authorization", 
                  `Bearer ${window.localStorage.getItem('jwt')}`) 
            },
            dataType: 'json',
            data: { query: this.query },
            url: `api/v1/time_sheet?page=${this.page}&limit=${this.options.perPage}&orderBy=${this.orderBy.column}&ascending=${this.orderBy.ascending}&mlc_id=${this.options.params.mlc_id}`
          }).done((jsres) => {
            window.localStorage.setItem('totalTime', jsres.total_time)
          })
        },
        params: {
          mlc_id: this.medicoLegalCaseId
        },
        columnsClasses: {
          id: 'ts-id',
          start_date: 'ts-patient',
          end_date: 'ts-end-date',
          description: 'ts-description',
          duration: 'ts-duration',
          note: 'ts-note',
          delete: 'ts-delete'
        },
        headings: {
          id: 'ID',
          start_date: 'Start',
          end_date: 'End',
          description: 'Description',
          duration: 'Duration',
          note: 'Note',
          delete: 'Delete'
        },
        skin: `table-bordered table table-responsive table-striped table-time-sheet`,
        sortIcon: {
          base : 'fas',
          is: 'fa-sort',
          up: 'fa-sort-up',
          down: 'fa-sort-down'
        },
        highlightMatches: true,
        perPageValues: [10, 25, 50],
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
        editableColumns:['description', 'note'],
        sortable: ['id', 'start_date','end_date'],
        filterable: false
      },
      page: 1,
      query: '',
      orderBy: 'id',
      byColumn: 'id',
      count: 0,
      ascending: false,
      columns: [
        'id', 'start_date', 'end_date', 'description', 'duration', 'note', 'fee', 'delete'
      ]
    }
  },
  computed: {
    tableIds() {
      return this.$refs['time-sheet']
        .data.map((i) => { return i.id })
        .join(",")
    }
  }
}
</script>
<style scoped>
th.ts-description {
  width: 220px !important;
}
</style>