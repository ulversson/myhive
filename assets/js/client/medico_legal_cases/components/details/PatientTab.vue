<template>
  <div class="card" style='margin-bottom: 0'>
    <div class="card-body">
      <h5 class="mb-3 text-default">
        <strong>
          <i class='fa fa-2x fa-user-md'></i>
          &nbsp;{{this.patientName}}
          <i class="fas fa-skull-crossbones text-danger" v-if='medicoLegalCase.patient.deceased'></i>&nbsp;
        </strong>   
      </h5>
      <dl class="row">
        <dt class="col-xl-4" v-if='hasDOB()'>Date of Birth</dt>
        <dd class="col-xl-8" v-if='hasDOB()'>
          <i class="fas fa-birthday-cake"></i>&nbsp;
          {{ this.parsedDate(medicoLegalCase.patient.date_of_birth) }}
        </dd>
        <dt class="col-xl-4" v-if='hasDOD()'>
          Date of Death
        </dt>
        <dd class="col-xl-8" v-if='hasDOD()'>
          <i class="fas fa-skull-crossbones text-danger"></i>&nbsp;
          {{this.parsedDate(medicoLegalCase.patient.date_of_death) }}
        </dd>
      </dl>  
      <common-address :medicoLegalCase='medicoLegalCase' :entity="'patient'"/> 
    </div>
  </div>
</template>
<script>
import shared from '../../mixins/shared'
import globals from '../../mixins/globals'
import CommonAddress from './CommonAddress.vue'
export default {
  mixins: [shared, globals],
  props: ['medicoLegalCase'],
  components: {CommonAddress},
  methods: {
    hasDOB() {
      return this.medicoLegalCase.patient.date_of_birth !== null
    },
    hasDOD() {
      return this.medicoLegalCase.patient.date_of_death !== null
    }
  }
}
</script>