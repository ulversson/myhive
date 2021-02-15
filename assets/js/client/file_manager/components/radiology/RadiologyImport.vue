<template>
  <div class='import' :data-id="`${radiologyImport.id}`">
    <div class="card-header">
      <a class="text-body collapsed"
        :data-id="`${radiologyImport.id}`" 
        @click="collapse(radiologyImport.id)"
        data-toggle="collapse" 
        :href="`accordion-${radiologyImport.id}`" 
        aria-expanded="false">
        <i class='fa fa-exclamation text-danger' 
          v-if='radiologyImport.error'></i>
        {{ radiologyImport.name }}
      </a>
      <span class='text-muted pull-right' style='float: right'>
          Imported {{ importedDate }}
        <a @click="removeImport(radiologyImport.id)"
          v-if="isAdmin">
          <i class='text-danger far fa-minus-square'></i>
        </a>  
      </span>
      </div>
    <div :id="`accordion-${radiologyImport.id}`" 
      class="collapse" data-parent="#accordion" style="">
        <div class="card-body card-with-shadow cui-payment-account">
          <div class="col-12">
            <div class="mb-5">
              <div class="cui-payment-account-icon">
                <i class="icmn-file-zip"></i>
              </div>
              <h5 class="text-black">
                <quick-edit v-model="radiologyImport.name" 
                  @input="saveName"
                  :validator="confirmNameSave"
                  :emptyText="'cannot be blank'"
                  v-if="isAdmin"
                  :classes="vueQuickEditClasses"></quick-edit>
                <strong v-if="!isAdmin">
                  {{ radiologyImport.name }}
                </strong>
              </h5>
              <p class="text-muted">
                {{radiologyImport.description}}
              </p>
            </div>
            <div class='buttons'>
            <a class="btn btn-icon btn-outline-success mt-3"
              :href='`/radiology_imports/${this.radiologyImport.id}/download`'
              data-toggle='tooltip' data-title='Download PACS zip archive'>
              <i class="icmn-download" aria-hidden="true"></i>
              &nbsp;Download
            </a>
            <a class="btn btn-icon btn-outline-info mt-3"
              @click="showLog()"
              data-toggle='tooltip' data-title='Show Import Log'>
              <i class="fas fa-info-circle" aria-hidden="true"></i>
              &nbsp;Import Log
            </a>
            <a class="btn btn-icon btn-outline-danger mt-3"
              v-if="radiologyImport.error"
               data-toggle='tooltip' data-title='Show Error Log'
              @click="showError()">
              <i class="fas fa-exclamation" aria-hidden="true"></i>
              &nbsp;Error Log
            </a>
            </div>
          </div>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment'
import QuickEdit from 'vue-quick-edit'
import shared from '../../../medico_legal_cases/mixins/shared'
import UI from '../../../../ui'
export default {
  props: ['radiologyImport'],
  data() {
    return {
      vueQuickEditClasses: {
        wrapper: 'radiology',
        input: 'form-control input-sm',
        buttons: 'btn-group btn-group-sm',
        buttonOk: 'btn btn-myhive mr-3',
        buttonCancel: 'btn btn-secondary mr-3',
      }
    }
  },
  methods: {
    removeImport(id) {
      UI.runConfirmedAction('fal fa-trash-alt', 
        "DELETE", "Remove this archive", 
        "You won't be able to revert this", 
        `/api/v1/radiology_imports/${id}`, () => {
          $(`div.import[data-id='${id}']`).remove()
        })
    },
    saveName(name) {
      $.ajax({
        url: `/api/v1/radiology_imports/${this.radiologyImport.id}/name`,
        type: 'PATCH',
        data: {id: this.radiologyImport.id, name: name}
      }).done((res) => {
        this.$nextTick(() => {
          this.$parent.$parent.$parent.loadImports()
        })
      }).fail((r) => {
        this.$swal('Error', 'Unable to update name', 'error')
      })
    },
    confirmNameSave(name) {
      if (!name) {
        this.$swal('Error', 'Name cannot be blank', 'error')
      } else if (!name.toLowerCase().endsWith(('.zip'))) {
        this.$swal('Error', 'Name must end with .zip file extension', 'error')
      } else {
        return ''
      }
    },
    collapse(id) {
      $(`#accordion-${id}`).collapse('toggle')
      $("[data-toggle='tooltip']").tooltip()
    },
    showLog() {
      this.$swal({
        title: 'Import log',
        html: `<pre>${this.radiologyImport.result}</pre>`,
        showCloseButton: false,
        showCancelButton: false,
        focusConfirm: false,
      })
    },
    showError() {
      this.$swal({
        title: 'Error log',
        html: `<pre>${this.radiologyImport.error}</pre>`,
        showCloseButton: false,
        showCancelButton: false,
        focusConfirm: false,
      })
    }
  },
  mixins: [shared],
  components: { QuickEdit },
  computed: {
    importedDate() {
      return moment.utc(this.radiologyImport.imported_at)
        .format('LLLL')
    }
  }
}
</script>
<style type="text/css">
  .radiology .vue-quick-edit__link {
    white-space: pre-wrap !important;
    color: black !important;
}
</style>