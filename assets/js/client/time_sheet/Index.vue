<template>
  <section id="card cui-utils-card-with-sidebar 
    cui-utils-card-with-sidebar-large bg-white">
    <Buttons :formVisible.sync="formVisible" :ids="ids"/>
    <NewEntry ref="newForm" v-show="formVisible"/>
    <TableList v-if="!formVisible" 
      :medicoLegalCaseId="medicoLegalCaseId"
      ref="table" />
  </section>
</template>
<script>
import Buttons from './Buttons.vue'
import NewEntry from './form/NewEntry.vue'
import TableList from './TableList.vue'
import serialization from '../time_sheet/mixins/serialization'
import roomManager from '../chat/mixins/roomManager'
import commonIndex from '../time_sheet/mixins/commonIndex'
export default {
  components: { Buttons, NewEntry, TableList },
  mixins: [serialization, roomManager, commonIndex]
}
</script>