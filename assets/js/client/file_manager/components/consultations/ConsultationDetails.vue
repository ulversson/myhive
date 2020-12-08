<template>
  <div class="consultation-details">
    <div class="row">
      <dt class="col-xl-4">Date</dt>
      <dd class="col-xl-8">
        <span
          class="text-capitalize badge badge-pill badge-alt badge-secondary"
          style="font-size: 16px;">
          <i class="far fa-clock"></i>
          {{ consultationFormattedDate }}&nbsp;
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.blood_pressure">
        Blood pressure
      </dt>
      <dd class="col-xl-8" v-if="consultation.blood_pressure">
        <span
          class="text-capitalize badge badge-pill badge-alt badge-danger"
          style="font-size: 16px;">
          <i class="fas fa-tint"></i>
          {{ consultation.blood_pressure }}&nbsp; mmHg
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.temperature">Temperature</dt>
      <dd class="col-xl-8" v-if="consultation.temperature">
        <span
          class="text-capitalize badge badge-pill badge-alt badge-warning"
          style="font-size: 16px;">
          <i class="fas fa-thermometer-half"></i>
          {{ consultation.temperature }}&#8451;
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.weight">Weight</dt>
      <dd class="col-xl-8" v-if="consultation.weight">
        <span
          class="text-capitalize badge badge-pill badge-alt purple-badge text-white"
          style="font-size: 16px;">
          <i class="fas fa-balance-scale"></i>
          {{ consultation.weight }}&nbsp;kg
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.height">Height</dt>
      <dd class="col-xl-8" v-if="consultation.height">
        <span
          class="text-capitalize badge badge-pill badge-alt badge-success text-white"
          style="font-size: 16px;"
        >
          <i class="fas fa-arrow-up"></i>
          {{ consultation.height }}&nbsp;cm
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.bmi">BMI</dt>
      <dd class="col-xl-8" v-if="consultation.bmi">
        <span
          class="text-capitalize badge badge-pill badge-alt badge-info text-white"
          style="font-size: 16px;">
          <i class="fas fa-dashboard"></i>
          {{ consultation.bmi }}&nbsp;kg/m2
        </span>
      </dd>
      <dt class="col-xl-4" v-if="consultation.covid_consent">
        Covid-19 Consent?
      </dt>
      <dd class="col-xl-8" v-if="consultation.covid_consent">
        <span
          class="text-capitalize badge badge-pill badge-alt text-white"
          :class="
            consultation.covid_consent === true
              ? 'badge-success'
              : 'badge-danger'"
          style="font-size: 16px;">
          {{ consultation.covid_consent === true ? "yes" : "no" }}
        </span>
        <i class="fas fa-check text-success"
          v-if="consultation.covid_consent == true"></i>
        <i
          class="fas fa-ban text-danger"
          v-if="consultation.covid_consent !== true"></i>
      </dd>
    </div>
    <code v-if="consultation.note !== '' && consultation.note !== null">
      <pre style="  white-space: normal;word-break: keep-all; text-align: justify">
        {{ consultation.note.trim() }}
      </pre>
    </code>
  </div>
</template>
<script>
export default {
  props: ['consultation'],
  computed: {
    consultationFormattedDate() {
      return moment(this.consultation.consultation_date).format('DD/MM/YYYY HH:MM')
    }
  }
}
</script>