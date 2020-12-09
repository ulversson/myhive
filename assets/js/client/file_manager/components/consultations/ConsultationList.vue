<template>
  <div class='col-12'>
    <Header :currentFolderId="currentFolderId" 
      :currentFolder.sync="currentFolder"
      :disableBack="true"
      ref='headerPanel'/> 
    <div class="accordion md-accordion" 
      id="consultations" role="tablist" :key="consultation.id"
      v-for="(consultation, index) in consultations" aria-multiselectable="true">
      <Consultation 
        :ref="`con-${consultation.id}`"
        :consultation="consultation" 
        :order="index+1" />
    </div>
  </div>
</template>
<script>
import Consultation from './Consultation.vue'
import Header from './ConsultationFileManagerHeader.vue'
export default {
  props: ['medicoLegalCaseId', 'consultations'],
  components: { Header, Consultation }
}
</script>