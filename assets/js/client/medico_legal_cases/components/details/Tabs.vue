<template>
  <modal 
    :name="`tabs-modal-${medicoLegalCaseId}`"
    :min-width="200"
    :min-height="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    width="40%"
    height="auto">
  <div class="nav-tabs-horizontal p-1 m-1">
  <ul class="nav nav-tabs" role="tablist">
    <li class="nav-item"  data-title='Medico legal case details' data-toggle='tooltip' data-placement='top'>
      <a class="nav-link active"
        href="javascript: void(0);" data-toggle="tab" data-target="#summary" role="tab"
        aria-selected="false">
        <i class='fa fa-briefcase text-secondary'></i>&nbsp;Details
      </a>
    </li>
    <li class="nav-item" data-title='Patient details' data-toggle='tooltip' data-placement='top'>
      <a class="nav-link" href="javascript: void(0);" data-toggle="tab" data-target="#patient" role="tab"
        aria-selected="true">
         <i class='fa fa-user-md text-secondary'></i>&nbsp;Patient
      </a>
    </li>
    <li class="nav-item" v-show='medicoLegalCase && medicoLegalCase.claimant !== null'>
      <a class="nav-link" href="javascript: void(0);" data-toggle="tab"
        data-target="#claimant" role="tab"
        aria-selected="false">
        <i class='icmn-user-tie text-secondary'></i>&nbsp;Claimant
      </a>
    </li>
      <li class="nav-item" v-show='medicoLegalCase && medicoLegalCase.instructing_party !== null'>
        <a class="nav-link" href="javascript: void(0);" 
          data-toggle="tab" data-target="#instructing-party" role="tab"
          aria-selected="false">
          <i class='icmn-office text-secondary'></i>&nbsp;Instructing Party  
        </a>
      </li>
  </ul>
  <tabs-content :medicoLegalCase="medicoLegalCase"/>
  </div>
    <button class='btn btn-primary pull-right m-3 mt-1' style='float: right' 
      @click="modalClose()">
      Close
    </button>
  </modal>
</template>

<script>
import TabsContent from './TabsContent.vue'
export default {
   methods: {
    modalClose() {
      this.$modal.hide(`tabs-modal-${this.medicoLegalCaseId}`)
    }
  },
  props: ['medicoLegalCase', 'medicoLegalCaseId'],
  components: { TabsContent }
}
</script>