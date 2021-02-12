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
      formattedDate(date) {
        return moment(date).format('DD/MM/YYYY')
      },
      sectionItem(section) {
        return this.form.$refs.tabs.$refs[`editor-${section.id}`][0]
      },
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
            //this.form.isLoaded = true
            this.form.reportId = report.id
            this.form.$refs.userSelect.selectedUser = report.user
            this.loadSections(report)
          })
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
        const ordered = report
          .report_template
          .report_sections.sort((a,b) => a.order - b.order)
        const sections = Fn.groupMapsByKey(report.report_section_contents, 'header')

        ordered.forEach((orderedSection) => {
          const section = orderedSection.report_section
          const itemLength = sections[section.letter].length
          this.$nextTick(() => {
            sections[section.letter]
              .sort((a,b) => a.order - b.order)
              .forEach((secContent, index) => {
                var sectionLength = this.form.$refs.tabs.items(section.letter).length
                if (sectionLength < itemLength ) {
                  this.form.$refs.tabs.addSection(section.letter)
                } else if (sectionLength >  itemLength) {
                  while (sectionLength >  itemLength) {
                    this.form.$refs.tabs.removeSection(section.letter)
                    sectionLength = this.form.$refs.tabs.items(section.letter).length

                  }
                }
                setTimeout(() => {
                  let editor = this.sectionItem(section).$refs[`editor-${section.id}`][index]
                  if (secContent.occurred_on) {
                    this.sectionItem(section).dates[index] = this.formattedDate(secContent.occurred_on)
                  }
                  if (secContent.timestamp && secContent.timestamp !== 'HH:mm') {
                    const item = this.sectionItem(section)
                    item.$refs[`time-${section.id}`][index].hour = secContent.timestamp.split(':')[0]
                      item.$refs[`time-${section.id}`][index].minute = secContent.timestamp.split(':')[1]
                    this.sectionItem(section).$forceUpdate()
                  } else if (secContent.timestamp) {
                 
                  }
                  editor.content = secContent.content 
                  this.sectionItem(section).$forceUpdate()
                }, 300)
              })
        }) 
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