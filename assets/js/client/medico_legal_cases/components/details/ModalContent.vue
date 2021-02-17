<template>
  <div class="nav-tabs-horizontal p-1 m-1" style="width: 100% !important">
    <ul class="nav nav-tabs" role="tablist">
      <li class="nav-item"  data-title='Medico legal case details' data-toggle='tooltip' data-placement='top'>
        <a class="nav-link"
          href="javascript: void(0);" data-toggle="tab" :data-target="`#${targetItem('summary')}`" 
          role="tab"
          :class="activeTabClass === 'summary' ? 'active': '' "
          @click="setActive('summary')"
          aria-selected="false">
          <i class='fa fa-briefcase text-secondary'></i>&nbsp;Details
        </a>
      </li>
      <li class="nav-item" data-title='Patient details' data-toggle='tooltip' data-placement='top'>
        <a class="nav-link" href="javascript: void(0);" data-toggle="tab" :data-target="`#${targetItem('patient')}`" role="tab"
          @click="setActive('patient')"
          :class="activeTabClass === 'patient' ? 'active': ''"
          aria-selected="true">
           <i class='fa fa-user-md text-secondary'></i>&nbsp;Patient
        </a>
      </li>
      <li class="nav-item" v-show='medicoLegalCase && medicoLegalCase.claimant !== null'>
        <a class="nav-link" href="javascript: void(0);" data-toggle="tab"
          :data-target="`#${targetItem('claimant')}`" role="tab"
          @click="setActive('claimant')"
          :class="activeTabClass === 'claimant' ? 'active': ''"
          aria-selected="false">
          <i class='icmn-user-tie text-secondary'></i>&nbsp;Claimant
        </a>
      </li>
        <li class="nav-item" v-show='medicoLegalCase && medicoLegalCase.instructing_party !== null'>
          <a class="nav-link" href="javascript: void(0);" 
            data-toggle="tab" :data-target="`#${targetItem('instructing-party')}`" 
            role="tab"
            :class="activeTabClass === 'instructing-party' ? 'active': ''"
            @click="setActive('instructing-party')"
            aria-selected="false">
            <i class='icmn-office text-secondary'></i>&nbsp;Instructing Party  
          </a>
        </li>
    </ul>
    <tabs-content :medicoLegalCase.sync="medicoLegalCase" :activeClass='activeTabClass'/>
  </div>
</template>
<script type="text/javascript">
  import TabsContent from './TabsContent.vue'
  export default {
    props: ['medicoLegalCase','medicoLegalCaseId'],
    components: { TabsContent },
          data() {
        return {
          activeTabClass: 'summary'
        }
  },
    methods: {
      targetItem(item) {
        return window.location.pathname.match("folders") ?
          `f-${item}` : item
      }, 
      setActive(item) {
        this.activeTabClass = item
      }
    }
  }
</script>