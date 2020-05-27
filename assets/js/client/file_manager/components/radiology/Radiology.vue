<template>
  <modal 
    name="radiology"
    :min-width="200" :min-height="250"
    :adaptive="true" :scrollable="true"
    :height="'auto'"
    :reset="true"
    @opened="afterOpened" 
    width="50%" >
    <div class='card'>
      <div class='card-header'>
        <span class='cui-utils-title'>Radiology</span>
      </div>
      <div class='card-body'>
        <button class="cui-github-explore-sort-option btn btn-sm btn-success text-white"
          @click="openBrowser()">
          <i class='fas fa-eye'></i>&nbsp;
          BROWSE
        </button>
        <RadiologyImports :imports="imports" />
      </div>
    </div>
  </modal>
</template>
<script>
import RadiologyImports from './RadiologyImports.vue'
export default {
  components: {
    RadiologyImports
  },
  data(){
    return {
      imports: []
    }
  },
  computed: {
    caseId() {
      return this.$store.state.currentMedicoLegalCaseId
    }
  },
  methods: {
    loadImports() {
      $.getJSON(`/api/v1/radiology_imports/${this.caseId}`, (jsonResp) => {
        this.imports = jsonResp
      })
    },
    afterOpened() {
      this.loadImports()
    },
    openBrowser() {

    }
  }
}
</script>