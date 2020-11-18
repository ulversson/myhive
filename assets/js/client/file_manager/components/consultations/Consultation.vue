<template>
  <div class="card">
    <div class="card-header" role="tab" id="consultations">
      <a data-toggle="collapse" data-parent="#consultations" href="#" aria-expanded="true"
        :aria-controls="`cons-consultation.id`"
        class="toggle-cons"
        @click="collapse(consultation.id)">
        <h5 class="mb-0">
          {{order}}. {{consultationFormattedDate}} 
          <i class="fas fa-angle-down rotate-icon" v-if="!this.collapsed"></i>
          <i class="fas fa-angle-up rotate-icon" v-if="this.collapsed"></i>
        </h5>
      </a>
    </div>
    <div :id="`cons-${consultation.id}`" class='collapse' 
      role="tabpanel" aria-labelledby="headingOne1" data-parent="#consultations"
      style="font-size: 16px !important">
      <div class="card-body card-with-shadow">
        <div class="card-body">
          <h5 class="mb-3 text-default">
            <strong><i class="fa fa-2x fa-user-md" aria-hidden="true"></i>
            System ID&nbsp;{{consultation.id}}
            </strong>
          </h5> 
          <div class='row'>
            <dt class="col-xl-4">Consultation date</dt> 
            <dd class="col-xl-8">
              <span class="text-capitalize badge badge-pill badge-alt badge-secondary" 
                style="font-size: 16px;">
                <i class='far fa-clock'></i>
                {{ consultationFormattedDate }}&nbsp;
              </span> 
            </dd> 
            <dt class="col-xl-4" v-if="consultation.blood_pressure">Blood pressure</dt> 
            <dd class="col-xl-8" v-if="consultation.blood_pressure">
              <span class="text-capitalize badge badge-pill badge-alt badge-danger" 
                style="font-size: 16px;">
                <i class='fas fa-tint'></i>
                {{ consultation.blood_pressure }}&nbsp;
                mmHg
              </span> 
            </dd>
            <dt class="col-xl-4" v-if="consultation.temperature">Temperature</dt> 
            <dd class="col-xl-8" v-if="consultation.temperature">
              <span class="text-capitalize badge badge-pill badge-alt badge-warning" 
                style="font-size: 16px;">
                <i class='fas fa-thermometer-half'></i>
                {{ consultation.temperature }}&#8451;
              </span> 
            </dd>
            <dt class="col-xl-4" v-if="consultation.weight">Weight</dt> 
            <dd class="col-xl-8" v-if="consultation.weight">
              <span class="text-capitalize badge badge-pill badge-alt purple-badge text-white" 
                style="font-size: 16px;">
                <i class='fas fa-balance-scale'></i>
                {{ consultation.temperature }}&nbsp;kg
              </span> 
            </dd>
            <dt class="col-xl-4" v-if="consultation.height">Height</dt> 
            <dd class="col-xl-8" v-if="consultation.height">
              <span class="text-capitalize badge badge-pill badge-alt badge-success text-white" 
                style="font-size: 16px;">
                <i class='fas fa-arrow-up'></i>
                {{ consultation.height }}&nbsp;cm
              </span> 
            </dd>
            <dt class="col-xl-4" v-if="consultation.bmi">BMI</dt> 
            <dd class="col-xl-8" v-if="consultation.bmi">
              <span class="text-capitalize badge badge-pill badge-alt badge-info text-white" 
                style="font-size: 16px;">
                <i class='fas fa-dashboard'></i>
                {{ consultation.bmi }}&nbsp;kg/m2
              </span> 
            </dd>
            <dt class="col-xl-4" v-if="consultation.bmi">Covid-19 Consent?</dt> 
            <dd class="col-xl-8" v-if="consultation.bmi">
              <span class="text-capitalize badge badge-pill badge-alt text-white" 
                :class="consultation.covid_consent === true ? 'badge-success': 'badge-danger'"
                style="font-size: 16px;">
                {{ consultation.covid_consent === true ? 'yes' : 'no' }}
              </span> 
              <i class='fas fa-check text-success' v-if="consultation.covid_consent == true"></i>
              <i class='fas fa-ban text-danger' v-if="consultation.covid_consent !== true"></i>
            </dd>
          </div>
          <code v-if="consultation.note !== '' && consultation.note !== null">
            <pre style='  white-space: normal;word-break: keep-all; text-align: justify'>
              {{ consultation.note.trim() }}
            </pre>
          </code>
          <div class='buttons' style='float: right'>
            <button class="btn btn-icon btn-xs btn-rounded btn-outline-warning mt-2 ml-2 pull-right"
              @click="editConsultation()"
              data-toggle='tooltip' data-title='Edit consultation'>
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn btn-icon btn-xs btn-rounded btn-outline-danger mt-2 ml-2 pull-right"
              data-toggle='tooltip' 
              @click="removeConsultation()"
              data-title='Remove consultation'>
              <i class="fas fa-trash-alt"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['consultation', 'order'],
  computed: {
    consultationFormattedDate() {
      return moment(this.consultation.consultation_date).format('DD/MM/YYYY HH:MM')
    }
  },
  data() {
    return {
      collapsed: true
    }
  },
  methods: {
    collapse(id) {
      $(`#cons-${id}`).collapse('toggle')
      $("[data-toggle='tooltip']").tooltip()
      this.collapsed = !this.collapsed
    },
    removeConsultation() {
      let vue = this;
      UI.runConfirmedAction(
        'fas fa-trash-alt', 
        'DELETE',
        'Remove this consultation entry',
        'All data will be irreversibly deleted',
        `/api/v1/patient_consultation/${this.consultation.id}`, 
        () => {
          let mainConsultation = this.$parent.$parent.$parent
          mainConsultation.loadConsultations()
        }, () => {}, vue)
    },
    editConsultation() {
      this.$root.$emit('toggleConsultation', true)
      this.$root.$emit('consultation', consultation)
    }
  }
}

</script>
<style scoped>
.purple-badge {
  background: #ba04ba; 
  border: 1px solid #ba04ba
}
.orange-badge {
  background: #e0a500; 
  border: 1px solid #ddbc04
}
</style>