<template>
  <div id="accordion" style='margin-top: 20px'>
    <div class="card mb-2" 
      v-for="(radiologyImport) in imports" 
      :key="radiologyImport.id">
      <RadiologyImport 
        :radiologyImport="radiologyImport" />
    </div>
  </div>
</template>
<script>
import RadiologyImport from './RadiologyImport.vue'
export default {
  props: ['imports'],
  components: {
    RadiologyImport
  }
}
</script>