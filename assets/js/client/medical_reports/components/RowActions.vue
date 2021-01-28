<template>
	<td>
    <a data-toggle="tooltip" data-title="Load into form" class="btn btn-icon btn-xs btn-outline-success mr-2 mb-2 btn-rounded"
      @click="loadReport">
      <i class="fal fa-redo-alt"></i>
    </a> 
    <a v-if="hasDocument" 
      data-toggle="tooltip" data-title="Open folder containing report" 
      class="btn btn-icon btn-xs btn-outline-info mr-2 mb-2 btn-rounded"
      @click="openFolder">
      <i class="fal fa-folder-open"></i>
    </a>
    <a v-if="hasDocument" 
      data-toggle="tooltip" data-title="Downlad PDF version" 
      :href="`/downloads/${report.file_asset_id}`"
      class="btn btn-icon btn-xs btn-outline-secondary mr-2 mb-2 btn-rounded">
      <i class="fal fa-download"></i>
    </a>
     <a 
      data-toggle="tooltip" data-title="Preview report on a separate tab" 
      class="btn btn-icon btn-xs btn-outline-warning mr-2 mb-2 btn-rounded"
      @click="preview">
      <i class="fal fa-eye"></i>
    </a>
    <a data-toggle="tooltip" data-title="Remove report" 
      class="btn btn-icon btn-xs btn-outline-danger mr-2 mb-2 btn-rounded"
      @click="deleteReport">
      <i class="fal fa-trash-alt"></i>
    </a>
  </td>
</template>
<script>
  export default {
    props: ['report'],
    methods: {
      openFolder() {
        this.$modal.hide('new-report')
        window.fileManager.$children[0].setCurrentFolder(this.report.folder_id)
        setTimeout(() => {
          $(`tr[data-id='${this.report.file_asset_id}'`).addClass('new')
        }, 500)
      },
      preview() {
        window.open(this.previewUrl, "_blank")
      },
      deleteReportRequest() {
        $.ajax({
          url: `/api/v1/reports/${this.report.id}`,
          type: "DELETE"
        }).done((res) => {
          this.history.loadUserReports(this.history.loadReportsUrl)
        }).fail(err => {
          this.$swal('Error', 'Unable to delete this report', 'error')
        })
      },
      loadReport() {
        $.ajax({
          url: `/api/v1/report/${this.report.id}`,
          type: 'GET'
        }).done((report) => {
          this.$nextTick(() => {
            this.$root.$emit('selectedTemplate', report.report_template)
            this.templateSelect.setSelected(report.report_template)
            this.form.isLoaded = true
            this.form.reportId = report.id
            this.form.$refs.userSelect.selectedUser = report.user
          })
          this.loadSections(report)
          $("a.nav-link.current").click()
        })
      },
      deleteReport() {
        this.$swal({
          title: 'Would you like to remove this report',
          message: "You cannot revert this action. Report will be deleted with the corresponding files (if there are any)",
          showCancelButton: true,
          confirmButtonText: `Delete`,
      }).then((result) => {
        if (result.isConfirmed) {
         this.deleteReportRequest()
        }
        })
      },
      loadSections(report) {
        report.report_section_contents.forEach((section, index) => {
          setTimeout(() => {
            let editor = this.form.$refs[`editor-${index}`][0]
            editor.content = section.content 
          }, 300)
        })
      }
    },
    computed: {
      previewUrl() {
        return `${window.location.origin}/report/${this.report.id}`
      },
      hasDocument() {
        return this.report.file_asset_id !== null
      },
      history() {
        return this.$parent.$parent.$parent.$parent.$refs.history
      },
      form() {
        return this.$parent.$parent.$parent.$parent.$refs.form
      },
      templateSelect() {
        return this.form.$refs.template
      }
    }
  }
</script>