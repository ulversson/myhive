<template>
  <section id="card cui-utils-card-with-sidebar 
    cui-utils-card-with-sidebar-large bg-white">
    <TableList v-if="!formVisible" 
      :medicoLegalCaseId="medicoLegalCaseId"
      ref="table" />
  </section>
</template>
<script>
import TableList from './ExtendedTableList.vue'
import serialization from '../time_sheet/mixins/serialization'
import roomManager from '../chat/mixins/roomManager'
import commonIndex from '../time_sheet/mixins/commonIndex'
export default {
  components: { TableList },
  mixins: [serialization, roomManager, commonIndex]
}
</script>