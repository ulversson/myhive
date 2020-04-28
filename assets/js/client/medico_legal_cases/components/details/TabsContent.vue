<template>
  <div class="tab-content">
    <div class="tab-pane active" id="summary">
      <summary-tab :medicoLegalCase="medicoLegalCase"/>
    </div>
    <div class="tab-pane" id="patient">
      <patient-tab :medicoLegalCase="medicoLegalCase"/>
    </div>
    <div class="tab-pane" id="claimant" v-show='showClaimant'>
      <claimant-tab :medicoLegalCase="medicoLegalCase" 
        v-show='showClaimant'/>
    </div>
    <div class="tab-pane" id="instructing-party" v-show='showInstructingParty'>
      <instructing-party-tab :medicoLegalCase="medicoLegalCase" 
        v-show='showInstructingParty'/>
    </div>
  </div>    
</template>
<script>
import SummaryTab from './SummaryTab.vue'
import PatientTab from './PatientTab.vue'
import ClaimantTab from './ClaimantTab.vue'
import InstructingPartyTab from './InstructingPartyTab.vue'
export default {
  props: ['medicoLegalCase'],
  components: {
    SummaryTab, PatientTab, ClaimantTab, InstructingPartyTab
  },
  computed: {
    showClaimant() {
      return this.medicoLegalCase.claimant !== null
    },
    showInstructingParty() {
      return this.medicoLegalCase.instructing_party !== null
    }
  }
}
</script>