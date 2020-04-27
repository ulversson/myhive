<template>
  <div class="tab-content">
    <div class="tab-pane active" id="summary">
      <summary-tab :medicoLegalCase="medicoLegalCase"/>
    </div>
    <div class="tab-pane" id="patient">
      Tab 2
    </div>
    <div class="tab-pane" id="claimant">
      Tab 3
    </div>
  </div>    
</template>
<script>
import SummaryTab from './SummaryTab.vue'
export default {
  props: ['medicoLegalCase'],
  components: {
    SummaryTab
  }
}
</script>