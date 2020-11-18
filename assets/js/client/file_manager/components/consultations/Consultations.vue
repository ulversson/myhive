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
        v-if="showConsultationForm === false && consultations.length <= 0">
        There are no consultations yet. Please click above to add.
      </div>
      <ConsultationList 
        :medicoLegalCaseId="medicoLegalCaseId"
        :consultations="consultations"
        v-if="showNewConsultationForm === false" />
      <NewConsultation v-if="showNewConsultationForm" />
    </div>
  </modal>
</template>
<script>
import NewConsultation from "./NewConsultation.vue";
import ConsultationList from './ConsultationList.vue';
export default {
  props: ["name"],
  components: { NewConsultation, ConsultationList },
  created() {
    this.$root.$on('toggleConsultation', (val) => {
      this.showNewConsultationForm = val
    })
  },
  data() {
    return {
      showNewConsultationForm: false,
      consultations: []
    }
  },
  methods: {
    afterOpen() {
      this.name = this.patientName;
      this.loadConsultations()
    },
    showConsultationForm() {
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
