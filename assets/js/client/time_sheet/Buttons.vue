<template>
  <div class='buttons'>
    <a @click="addEntry()" id="add-new-time-entry"
      v-if="!formVisible" 
      class="btn btn-sm btn-primary ml-2">
      Add new entry&nbsp;
      <i class="fas fa-user-clock"></i>
    </a>
    <div class='pull-right' style='float: right'>
      <a class='pdf-download btn btn-danger btn-sm'
        :href="exportPdfUrl" v-if="!formVisible">
        <i class='far fa-file-pdf'></i>&nbsp;PDF
      </a>
      <a class='csv-download btn btn-success btn-sm'
        :href="exportXlsxUrl" v-if="!formVisible">
        <i class='far fa-file-excel'></i>&nbsp;
        Excel
      </a>
    </div>
  </div>
</template>
<script>
export default {
  props: ['formVisible','ids'],
  methods: {
    addEntry() {
      this.formVisible = true
      this.$parent.formVisible = true
    }
  },
  computed: {
    exportPdfUrl() {
      return `/time_sheet/export/pdf?ids=${this.ids}`
    },
    exportXlsxUrl() {
      return `/time_sheet/export/xlsx?ids=${this.ids}`
    }
  }
}
</script>