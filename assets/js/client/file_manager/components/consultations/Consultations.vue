<template>
  <modal
    name="consultations-modal"
    :min-width="200"
    :min-height="350"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    @opened="setPatientName"
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
      <NewConsultation v-if="showNewConsultationForm" />
    </div>
  </modal>
</template>
<script>
import NewConsultation from "./NewConsultation.vue";
export default {
  props: ["name"],
  components: { NewConsultation },
  created() {
    this.$root.$on('toggleConsultation', (val) => {
      this.showNewConsultationForm = val
    })
  },
  data() {
    return {
      showNewConsultationForm: false
    }
  },
  methods: {
    setPatientName() {
      this.name = this.patientName;
    },
    showConsultationForm() {
      this.showNewConsultationForm = true
    }
  },
  computed: {
    patientName() {
      let names = $("strong.case-header")
        .html().split(".");
      return `${names[0]} ${names[1].toUpperCase()}`;
    },
  },
};
</script>
