<template>
   <modal 
    :min-width="200"
    styles="top: 0; margin-left: 0px !important"
    name="edit-entry-description">
    <div class='card-body'>
      <div class='card-header' style='padding: 0px'>
        <h4>Change time entry description</h4>
      </div>
      <p>
        <textarea :data-id='row.id' 
          v-model="description"
          class='form-control col-md-12 autosize' rows="5">
        </textarea>
      </p>
      <div class='buttons' style='float: right; margin-bottom: 10px; margin-right: 10px'>
        <a class='text-white btn btn-primary' @click="saveDescFromText(row)">
          SAVE
        </a>
        &nbsp;
        <a class='text-white btn btn-secondary' @click="modalHide()">
          Cancel
        </a>      
      </div>
    </div>
   </modal>
</template>
<script>
import timeSheetUpdate from '../mixins/timeSheetUpdate'
export default {
  props: ['row'],      
  mixins: [timeSheetUpdate],
  methods: {
    modalHide() {
      this.$modal.hide('edit-entry-description')
    }
  },
  computed: {
    description() {
      if (this.row) {
        return this.row.description
      } else {
        return ''
      }
    }
  } 
}
</script>
<style>
.cui-menu-right-content .vm--container .vm--modal {
  top: 20  !important;
  left: 0 !important;
}
</style>