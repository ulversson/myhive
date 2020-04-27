<template>
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
    <li class="nav-item" data-title='Claimant details' data-toggle='tooltip' data-placement='top'>
      <a class="nav-link" href="javascript: void(0);" data-toggle="tab"
        data-target="#claimant" role="tab"
        aria-selected="false">
        <i class=' icmn-user-tie text-secondary'></i>&nbsp;Claimant
        </a>
    </li>
    <li class="nav-item" data-title='Instructing Party details' data-toggle='tooltip'  data-placement='top'>
      <a class="nav-link" href="javascript: void(0);" data-toggle="tab" data-target="#instructing-party" role="tab"
        aria-selected="false">
      <i class=' icmn-office text-secondary'></i>&nbsp;Instructing Party  
      </a>
    </li>
  </ul>
  <tabs-content :medicoLegalCase="medicoLegalCase"/>
</div>
</template>

<script>
import TabsContent from './TabsContent.vue'
export default {
  props: ['medicoLegalCase'],
  components: {TabsContent }
}
</script>