<template>
  <modal
    name="consultations-modal"
    :min-width="200"
    :min-height="350"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    @opened="afterOpen"
    width="60%"
    height="auto">
    <div class="card-header equal-space"
      style="margin-top: .5rem !important">
      <h4>Consultations with {{ name }}</h4>
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"
			  style="margin-top: -2.5rem !important"
				@click="$modal.hide(`consultations-modal`)">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="card-body">
      <a href="javascript:void(0)"
        id="add-new-consultations"
        data-toggle="tooltip"
        v-if="showNewConsultationForm === false"
        @click="showConsultationForm()"
        title="Add new consultation entry"
        class="btn btn btn-myhive active mb-4 ml-3">
        <i class="fal fa-user-md"></i>
        Add new consultation&nbsp;
      </a>
      <Alert
        v-if="showNewConsultationForm === false && consultations.length <= 0"
        message="There are no consultations yet. Please click above to add.">
      </Alert>
      <ConsultationList 
        :medicoLegalCaseId="medicoLegalCaseId"
        :consultations="consultations"
        ref='conList'
        v-if="showNewConsultationForm === false" />
      <ConsultationForm v-if="showNewConsultationForm" 
        :consultation="consultation" />
    </div>
  </modal>
</template>
<script>
// @ts-nocheck

import Alert from '../Alert.vue'
import ConsultationForm from "./ConsultationForm.vue";
import ConsultationList from './ConsultationList.vue';
export default {
  components: { Alert, ConsultationForm, ConsultationList },
  created() {
    this.$root.$on('toggleConsultation', (val) => {
      this.showNewConsultationForm = val
    })
    this.$root.$on('consultation', (cons) => {
      this.consultation = cons
    })
  },
  data() {
    return {
      showNewConsultationForm: false,
      consultations: [],
      consultation: null,
      name: null
    }
  },
  methods: {
    afterOpen() {
      this.name = this.patientName;
      this.loadConsultations()
    },
    showConsultationForm() {
      this.consultation = null
      this.showNewConsultationForm = true
    },
    loadConsultations() {
      this.consultations.splice(0, this.consultations.length)
      $.getJSON(`/api/v1/consultations?mlc_id=${this.medicoLegalCaseId}`, 
        (jsonRes) => {
          jsonRes.data.forEach(consultation => {
            this.consultations.push(consultation)
          }); 
      })
    }
  },
  computed: {
    medicoLegalCaseId() {
      return window.localStorage.getItem('currentMedicoLegalCaseId')
    },
    patientName() {
      let names = $("strong.case-header")
        .html().split(".")
      return `${names[0]} ${names[1].toUpperCase()}`
    },
  },
};
</script>
<style>
h4.equal-space {
  padding-top: .5rem !important; 
  padding-bottom: .5rem !important;
  margin-top: .5rem !important;
}
</style>