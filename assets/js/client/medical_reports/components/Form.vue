<template>
	<div class='form form-horizontal col-12'>
		<div class='d-flex justify-content-center' style="width: 100%">
			<div class='col-6 m-0 p-0'>
				<TemplateSelect ref="template" :submit="submit" />
			</div>
			<div class='col-6 m-0 p-0'>
				<UserSelect ref="userSelect" :submit="submit" />
			</div>
		</div>
		<OutgoingEmailStorage 
			:textColor="textColor" 
			:preselect="'Medical Reports'"
			:label="'Save generated report in'"
			:submit.sync="submit"
			:fullTree="true" 
			ref="storage" />
		<SectionTabs :sections="sections" :template="template" ref="tabs"/>
		<ReportButtons 
			ref="buttons"
			:isButtonDisabled.sync="buttonDisabled" />
	</div>
</template>
<script>
import TemplateSelect from './TemplateSelect.vue'
import ReportButtons from './ReportButtons.vue'
import SectionTabs from './SectionTabs.vue'
import OutgoingEmailStorage from '../../file_manager/components/email_templates/send/OutgoingEmailStorage.vue'
import UserSelect from './UserSelect.vue'
import folderTree from '../../file_manager/mixins/folderTree'
const flatten = arr => arr.reduce(
  (a, b) => a.concat(Array.isArray(b) ? flatten(b) : b), []
);

export default {
	data() {
		return {
			isLoaded: false,
			reportId: null,
			submit: false
		}
	},
	mixins: [folderTree],
	props: ['sections', 'textColor', 'buttonDisabled', 'template', 'textColor'],
	components: {
		TemplateSelect, OutgoingEmailStorage, 
		ReportButtons, UserSelect, SectionTabs
	},
	methods: {
		hasErrors() {
			return this.$refs.userSelect.hasSelectError || this.$refs.storage.hasError() === true
		},
		reset() {
			this.reportId = null
			this.isLoaded = false
			this.submit = false
			this.$root.$emit('selectedTemplate', null)
			this.$set(this, 'sections', [])
			this.$set(this, 'buttonDisabled', true)
			this.$parent.template = null
			$("button.vs__clear").click()
		},
		saveSections(saveDocument = true) {
			return $.ajax({
				type: this.isLoaded ? 'PATCH' : 'POST',
				url: `/api/v1/reports/${this.template.id}/save_sections?save_doc=${saveDocument}`,
				data: this.formData
			})
		}
	},
	computed: {
		selectedUser() {
			let user = this.$refs.userSelect.selectedUser
 			if (user) {
 				return user.id
 			} else {
 				return null
 			}
		},
		formData() {
			const report = {
				report: {
					user_id: this.selectedUser,
					folder_id: this.$refs.storage.selectedValue, 
					medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
					report_template_id: this.template.id,
					report_template_sections: flatten(this.template.report_sections.map((s, idx) => {
						let se = s.report_section
						return this.$refs.tabs.$refs[`editor-${se.id}`][0].$refs[`editor-${se.id}`].map((editor, eidx) => {
								let occurredOn = this.$refs.tabs.$refs[`editor-${se.id}`][0].$refs[`date-${se.id}`]
								let time = this.$refs.tabs.$refs[`editor-${se.id}`][0].$refs[`time-${se.id}`]
								if (occurredOn) {
									occurredOn = moment(occurredOn[eidx].currentValue).format('YYYY-MM-DD')
								}
								if (time) {
									time = time[eidx].displayTime
								}
						return {
							report_template_id: this.template.id,
							report_section_id: se.id,
							timestamp: time,
							occurred_on: occurredOn, 
							report_template_section_id: this.template.report_sections[idx].id,
							content: editor.body()
							}
						})						
					})
				)//flatten
			}
		}
		if (this.reportId) {
			report.report["id"] = this.reportId
		}
		return report
	}
}
}
</script>