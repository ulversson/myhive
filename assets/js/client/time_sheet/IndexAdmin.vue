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
export default {
  components: { TableList },
  mixins: [serialization, roomManager],
  updated() {
    this.$refs.newForm.getDuration()
  },
  computed: {
    medicoLegalCaseId() {
      return this.$store.state.currentMedicoLegalCaseId
    }
  },
  watch: {
    formVisible: function(newVal, oldVal) {
      this.$root.$emit('show-recording', newVal)
      if (newVal && !this.initialFormVisible()) {
        this.serializeAndSaveForm()
      } 
      if (!newVal && this.initialFormVisible()) {
        this.clearSavedForm()
        this.$refs.newForm.resetForm()
      }
      if (newVal && this.initialFormVisible()) {
        let deserializedForm = this.deserializeForm()
        this.$refs.newForm.startTime = this.timeFromDate(deserializedForm.start_date)
        this.$refs.newForm.endTime = this.timeFromDate(deserializedForm.end_date)
        this.$refs.newForm.note = deserializedForm.note
        this.$refs.newForm.entryDate = deserializedForm.entry_date
        this.$refs.newForm.selectedUserId = deserializedForm.owner_id
        this.$refs.newForm.description = deserializedForm.description
        this.$refs.newForm.getDuration()
      }
    }
  },
  data() {
    return {
      formVisible: false,
      ids: ''
    }
  },
  mounted() {
    this.formVisible = this.initialFormVisible()
    this.$root.$on('show-recording', (isRecording) => {
      if (isRecording) {
        $("div.circle.red").show()
      } else {
        $("div.circle.red").hide()
      }
    })
  },
  created() {
    this.$on('ids', (ids) => {
      this.ids = ids
    })
  }
}
</script>