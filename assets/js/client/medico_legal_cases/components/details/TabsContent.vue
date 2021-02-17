<template>
  <div class="tab-content">
    <div class="tab-pane" :id="targetItem('summary')"
      :class="activeClass === 'summary' ? 'active': ''">
      <summary-tab :medicoLegalCase="medicoLegalCase"/>
    </div>
    <div class="tab-pane" :id="targetItem('patient')"
       :class="activeClass === 'patient' ? 'active': ''">
      <patient-tab :medicoLegalCase="medicoLegalCase"/>
    </div>
    <div class="tab-pane" :id="targetItem('claimant')" 
      :class="activeClass === 'claimant' ? 'active': ''"
      v-show='showClaimant'>
      <claimant-tab :medicoLegalCase="medicoLegalCase" 
        v-show='showClaimant'/>
    </div>
    <div class="tab-pane" :id="targetItem('instructing-party')" 
      :class="activeClass === 'instructing-party' ? 'active': ''"
      v-show='showInstructingParty'>
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
  props: ['medicoLegalCase', 'activeClass'],
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
  },
  methods: {
    targetItem(item) {
      return window.location.pathname.match("folders") ?
          `f-${item}` : item
    }
  }
}
</script>