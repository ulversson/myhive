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
    width="50%"
    height="auto">
    <div class="card-header">
      <h4>Consultations for {{ name }}</h4>
    </div>
    <div class="card-body">
      <a href="javascript:void(0)"
        id="add-new-consultations"
        data-toggle="tooltip"
        v-if="showNewConsultationForm === false"
        @click="showConsultationForm()"
        title="Add new consultation entry"
        class="btn btn btn-myhive active mb-4">
        <i class="fas fa-user-md"></i>
        Add new consultation&nbsp;
      </a>
      <div class='alert alert-info' 
        v-if="showNewConsultationForm === false && consultations.length <= 0">
        There are no consultations yet. Please click above to add.
      </div>
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
import ConsultationForm from "./ConsultationForm.vue";
import ConsultationList from './ConsultationList.vue';
export default {
  props: ["name"],
  components: { ConsultationForm, ConsultationList },
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
      consultation: null
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
        .html().split(".");
      return `${names[0]} ${names[1].toUpperCase()}`;
    },
  },
};
</script>
