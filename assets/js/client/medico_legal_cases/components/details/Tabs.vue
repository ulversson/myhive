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
    <ModalContent
      :medicoLegalCase.sync="medicoLegalCase"
      :medicoLegalCaseId.sync="medicoLegalCaseId" />
    <button class='btn btn-primary pull-right m-3 mt-1' style='float: right' 
      @click="modalClose()">
      Close
    </button>
  </modal>
</template>
<script>
import ModalContent from './ModalContent.vue'
export default {
   methods: {
    modalClose() {
      this.$modal.hide(`tabs-modal-${this.medicoLegalCaseId}`)
    }
  },
  props: ['medicoLegalCase', 'medicoLegalCaseId'],
  components: { ModalContent }
}
</script>