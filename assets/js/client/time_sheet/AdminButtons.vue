<template>
  <div class='buttons mb-2'>
    <div class='pull-right mb-3' style='float: right'>
      <a class='pdf-download btn btn-danger btn-sm'
        :href="exportPdfUrl" v-if="!formVisible">
        <i class='far fa-file-pdf'></i>&nbsp;
        PDF
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
  props: ['formVisible'],
  methods: {
    addEntry() {
      this.formVisible = true
      this.$parent.formVisible = true
    }
  },
  computed: {
    ids() {
      return this.$parent.ids
    },
    exportPdfUrl() {
      return `/time_sheet/export/pdf?ids=${this.ids}`
    },
    exportXlsxUrl() {
      return `/time_sheet/export/xlsx?ids=${this.ids}`
    }
  }
}
</script>