import timeSheetUpdate from './timeSheetUpdate'
export default {
  methods: {
    showEditDescription(vm, row) {
      this.$modal.show({
        template: `
          <div class='card-body'>
            <div class='card-header'>
              <h4>Edit entry description</h4>
            </div>
            <p>
              <textarea :data-id='row.id' class='form-control col-md-12 autosize' rows="5">{{ row.description }}</textarea>
            </p>
            <div class='buttons' style='float: right; margin-bottom: 10px'>
              <a class='text-white btn btn-primary' @click="saveDescFromText(row, fieldValue, table);$modal.hideAll()">
                SAVE
              </a>
              &nbsp;
              <a class='text-white btn btn-secondary' @click="$modal.hideAll()">
                Cancel
              </a>      
            </div>
          </div>
        `,
        props: ['row'],
        mixins: [timeSheetUpdate],
    
        computed: {
          fieldValue() {
            return  jQuery('textarea[data-id='+row.id +']').val().trim()
          }
        },
      },
      { row: row },
      { height: 'auto' })
    }
  }
}