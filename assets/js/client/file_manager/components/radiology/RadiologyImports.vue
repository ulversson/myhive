<template>
  <div id="accordion" style='margin-top: 20px'>
    <div class="card mb-2" 
      v-for="(radiologyImport) in orderedImports" 
      :key="radiologyImport.id">
      <RadiologyImport :radiologyImport="radiologyImport" />
    </div>
  </div>
</template>
<script>
import RadiologyImport from './RadiologyImport.vue'
export default {
  props: ['imports'],
  computed: {
    orderedImports() {
      return this.imports.sort((a, b) => {
        a.name - b.name
      })
    }
  },
  components: {
    RadiologyImport
  }
}
</script>