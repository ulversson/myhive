<template>
	<td>
    <a data-toggle="tooltip" data-title="Edit document" class="btn btn-icon btn-xs btn-outline-success mr-2 mb-2 btn-rounded"
      @click="loadReport">
      <i class="fal fa-redo-alt"></i>
    </a> 
    <a v-if="hasDocument" 
      data-toggle="tooltip" data-title="Find document in my-hive" 
      class="btn btn-icon btn-xs btn-outline-info mr-2 mb-2 btn-rounded"
      @click="openFolder">
      <i class="fal fa-folder-open"></i>
    </a>
    <a v-if="hasDocument" 
      data-toggle="tooltip" data-title="Downlad in PDF" 
      :href="`/downloads/${report.file_asset_id}?name=${downloadName}`"
      class="btn btn-icon btn-xs btn-outline-secondary mr-2 mb-2 btn-rounded">
      <i class="fal fa-download"></i>
    </a>
     <a 
      data-toggle="tooltip" data-title="Preview" 
      class="btn btn-icon btn-xs btn-outline-warning mr-2 mb-2 btn-rounded"
      @click="preview">
      <i class="fal fa-eye"></i>
    </a>
    <a data-toggle="tooltip" data-title="Delete" 
      class="btn btn-icon btn-xs btn-outline-danger mr-2 mb-2 btn-rounded"
      @click="deleteReport">
      <i class="fal fa-trash-alt"></i>
    </a>
  </td>
</template>
<script>
  import previewReport from '../mixins/previewReport'
  export default {
    props: ['report'],
    mixins: [previewReport],
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
        this.previewReport(this.previewUrl)
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
            if (this.form.$refs.userSelect) this.form.$refs.userSelect.selectedUser = report.user
            this.loadSections(report)
          })
          $("a.nav-link.current").click()
        })
      },
      deleteReport() {
        this.$swal({
          title: 'Would you like to remove this report',
          type: 'question',
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
          this.$nextTick(() => {
            if (sections[section.letter]) {
              sections[section.letter]
              .sort((a,b) => a.order - b.order)
              .forEach((secContent, index) => {
                debugger
                this.cleanupSection(sections, section)
                setTimeout(() => {
                 
                    this.setSectionData(section, secContent, index)
                }, 300)
              })
            } else {
              if (section.letter === 'GoT') {
                this.loadGlossaryOfTerms(report.glossary_of_terms, section)
              }
            }
          }) 
        })
        this.form.saveFormLocally()
        this.$root.$emit('setUpdatedDate', report.updated_at)
     },
     cleanupSection(sections, section) {
      const itemLength = sections[section.letter].length
      var sectionLength = this.form.$refs.tabs.items(section.letter).length
      if (sectionLength < itemLength ) {
        this.form.$refs.tabs.addSection(section.letter)
      } else if (sectionLength >  itemLength) {
        while (sectionLength >  itemLength) {
          this.form.$refs.tabs.removeSection(section.letter)
          sectionLength = this.form.$refs.tabs.items(section.letter).length
        }
      }
     },
     setSectionData(section, content, index) {
      let editor = this.sectionItem(section).$refs[`editor-${section.id}`][index]
      editor.content = content.content 
      if (content.occurred_on) {
        this.sectionItem(section).dates[index] = this.formattedDate(content.occurred_on)
      }
      if (content.timestamp && content.timestamp !== 'HH:mm') {
        const item = this.sectionItem(section)
        item.$refs[`time-${section.id}`][index].hour = content.timestamp.split(':')[0]
        item.$refs[`time-${section.id}`][index].minute = content.timestamp.split(':')[1]
        this.sectionItem(section).$forceUpdate()
      } 
      this.sectionItem(section).$forceUpdate()
     },
      loadGlossaryOfTerms(items, section) {
        if (!items) return 
        if (items.length === 0) return 
        const tagsPanel = this.form.$refs.tabs.$refs[`editor-${section.id}`][0]
        tagsPanel.items.splice(0, tagsPanel.items.length)
        debugger
        items.forEach((item, index) => {
          let selectedItem = {
            description: item.description,
            value: item.glossary_item.id,
            name: item.glossary_item.name,
            text: item.glossary_item.name,
            short_name: item.glossary_item.short_name,
            tiClasses: "ti-valid"
          }
          tagsPanel.items.push(selectedItem)
        })
      }
    },
    computed: {
      downloadName() {
        const name = this.report.report_template.name.replace(" Template", "")
        return `${name} Re ${this.report.patient_last_name} ${moment().format("DD MMM YYYY")}.pdf`
      },
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