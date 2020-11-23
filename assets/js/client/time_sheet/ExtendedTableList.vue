<template>
  <div id='time-sheet-entries' 
    class='mt-3 col-md-offset-2 col-md-12'>
    <admin-buttons 
      :formVisible.sync="formVisible" />
    <EditDescriptionModal :row.sync="row" v-if="row"/>
    <v-server-table 
      name="admin"
      :columns="columns" 
      :options="options" 
      ref='time-sheet-full'>
      <div slot="description" slot-scope="{row, isEditing}">
        <span @click="hidePopover();" v-if="!isEditing()">
          <a style='color: #08f !important' :data-content="row.description"
            @click="showEditDescription(row)"
            data-toggle="popover" data-trigger='hover' data-title="Description" class='inline-edit cui-utils-link-underlined cui-utils-link-blue'>
            Show
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
import CaseColumn from './columns/CaseColumn.vue'
import OwnerColumn from './columns/OwnerColumn.vue'
import AdminButtons from './AdminButtons.vue'
import EditDescriptionModal from './modal/EditDescriptionModal.vue'
import timeSheetUpdate from './mixins/timeSheetUpdate'
import { Event } from 'vue-tables-2'
export default {
  mixins: [timeSheetUpdate],
  props: ['medicoLegalCaseId', 'row'],
  components: { 
    CaseColumn,
    OwnerColumn,
    StartDateColumn, 
    EndDateColumn,
    DurationColumn,
    FeeColumn,
    AdminButtons,
    EditDescriptionModal
  },
  created() {
    Event.$on('vue-tables.admin.loaded', (data) => {
      let ids = data.data.map(i => i.id).join(",")
      this.$parent.$emit('ids', ids)
      this.ids = ids
      this.clearFilterPlaceholder()
    })
  },
  methods: {
    clearFilterPlaceholder() {
      $(".VueTables__filters-row input").attr('placeholder','')
      $('.VueTables__filter-placeholder').text('Filter')
    },
    hidePopover() {
      $(`a[data-toggle=popover]`).popover('hide')
    }, 
    showPopover() {
      setTimeout(() => {
        $("a[data-toggle='popover']").popover()
      }, 500)
    }
  },
  data() {
    return {
      ids: "",
      totalTime: window.localStorage.getItem('totalTime'),
      options:  {
        orderBy: {
          column: "id",
          ascending: "false"
        },
        filterByColumn: true,
        highlightMatches: true,
        templates: {
          case: CaseColumn,
          owner: OwnerColumn,
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
            url: `api/v1/time_sheet?page=${this.page}&limit=${this.options.perPage}&orderBy=${this.orderBy.column}&ascending=${this.orderBy.ascending}`
          }).done((jsres) => {
            window.localStorage.setItem('totalTime', jsres.total_time)
          })
        },
        params: {
          //mlc_id: this.medicoLegalCaseId
        },
        columnsClasses: {
          id: 'ts-id',
          case: 'ts-mlc',
          owner: 'ts-owner',
          start_date: 'ts-start-date',
          end_date: 'ts-end-date',
          duration: 'ts-duration',
          description: 'ts-description',
          note: 'ts-note',
          delete: 'ts-delete'
        },
        headings: {
          id: 'ID',
          case: 'Case',
          owner: 'Owner',
          start_date: 'Start',
          end_date: 'End',
          duration: 'Duration',
          description: 'Description',
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
        perPageValues: [],
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
        sortable: ['id', 'case', 'owner', 'start_date','end_date'],
        dateColumns:['start_date','end_date'],
        filterable: ['id', 'case', 'owner', 'start_date', 'end_date']
      },
      page: 1,
      query: '',
      orderBy: 'id',
      byColumn: 'id',
      count: 0,
      ascending: false,
      columns: [
        'id', 'case', 'owner', 'start_date', 'end_date', 'duration', 'description', 'note', 'fee', 'delete'
      ]
    }
  }
}
</script>