<template>
  <div class='row side-panel-details' v-if="medicoLegalCase">
    <ModalContent 
      :medicoLegalCaseId.sync="medicoLegalCaseId"
      :medicoLegalCase.sync="medicoLegalCase" />
    <a class="btn btn-icon btn-sm btn-outline-warning mr-2 mb-2 ml-2" 
      data-toggle='tooltip' 
      :href="`/medico_legal_cases/${medicoLegalCaseId}/edit?returnUrl=${documentUrl}`"
      data-title='Edit'>
      <i class="far fa-edit"></i>
    </a>
  </div>
</template>
<script type="text/javascript">
  import ModalContent from './components/details/ModalContent.vue'
  import caseLoader from './mixins/caseLoader'
  export default {
    components: { ModalContent },
    data() {
      return {
        medicoLegalCase: {
          patient: {
            addresses: []
          },
          users: [],
          user: {
            first_name: '',
            last_name: ''
          },
          instructed_by: '',
          claimant: null, 
          instructing_party: {
            addresses: []
          }
        }
      }
    },
    mixins: [caseLoader],
    computed: {
      medicoLegalCaseId() {
        return window.localStorage.getItem('currentMedicoLegalCaseId')
      },
      documentUrl() {
        return document.URL
      }

    },
    methods: {
      loadCaseData(caseId) {
         this.loadCaseDetails(caseId)
          .then((jsonResponse) => {
            this.$set(this, 'medicoLegalCase', jsonResponse.data)
        })
      }
    }
  }
</script>
