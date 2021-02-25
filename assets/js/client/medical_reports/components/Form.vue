<template>
	<form @input="saveFormLocally()" 
		data-id="" ref="curentForm"
		class='form form-horizontal col-12' style="max-height: 600px; overflow-y: scroll; ">
		<div class='d-flex justify-content-center' style="width: 100%">
			<div class='m-0 p-0 col-12'>
				<TemplateSelect ref="template" :submit="submit" />
			</div>
		</div>
		<div class='col-12 m-0 p-0' v-if="isAdmin">
			<UserSelect ref="userSelect" :submit="submit" />
		</div>
		<OutgoingEmailStorage 
			:textColor="textColor" 
			:preselect="'Medical Reports'"
			:label="'Save document in'"
			:submit.sync="submit"
			:fullTree="true" 
			ref="storage" />
		<SectionTabs :sections="sections" :template="template" ref="tabs"/>
		<ReportButtons 
			ref="buttons"
			:isButtonDisabled.sync="buttonDisabled" />
	</form>
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
	watch: {
		draftReport: function(newDraft, oldDraft) {
			if (newDraft) {
				newDraft.data.report.report_template = {}
				newDraft.data.report.report_template.report_sections = newDraft.report_sections
				newDraft.data.report.report_section_contents = newDraft.report_sections
				this.$parent.$parent.$refs.history.$refs["row-206"][0].$refs["action-206"].loadSections(newDraft.data.report)
			}
		}
	},
	data() {
		return {
			localForms: {},
			lastSaved: 'not saved yet',
			draftReport: {},
			isLoaded: false,
			reportId: null,
			submit: false
		}
	},
	mixins: [folderTree],
	props: ['sections', 'textColor', 'buttonDisabled', 'template', 'textColor', 'isAdmin'],
	components: {
		TemplateSelect, OutgoingEmailStorage, 
		ReportButtons, UserSelect, SectionTabs
	},
	methods: {
		saveFormLocally() {
			if (this.$refs.curentForm.dataset.id.length === 0) {
				this.$refs.curentForm.dataset.id = Fn.randomString() 
			} else {
				const currentId = this.$refs.curentForm.dataset.id
				//this.autosave(currentId)
			}
		},
		autosave(currentId) {
			return $.ajax({
				type: 'POST', 
				url: `/api/v1/reports/${currentId}/draft`, 
				data: {
					user_id: this.userOrDefault,
					unique_key: currentId, 
					document_json: this.formData,
					medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
					report_template_id: this.template.id
				}
			}).then((response) => {
				this.draftReport = response
			})			
		},
		loadDraft() {
			const caseId = window.localStorage.getItem('currentMedicoLegalCaseId')
			return $.ajax({
				type: 'GET', 
				url: `/api/v1/reports/load_draft/${caseId}/${this.userOrDefault}/${this.template.id}`
			}).done((res) => {
				debugger
				this.draftReport = res
			})
		},
		hasErrors() {
			if (this.isAdmin) {
				return  this.$refs.userSelect.hasSelectError || this.$refs.storage.hasError() 
			} else {
				return this.$refs.storage.hasError() 
			}
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
			if (!this.$refs.userSelect) return null;
			let user = this.$refs.userSelect.selectedUser
 			if (user) {
 				return user.id
 			} else {
 				return null
 			}
 		},
 		userOrDefault() {
 			return this.isAdmin ? this.selectedUser : Users.currentUserId()
		},
		formData() {
			const report = {
				report: {
					user_id: this.userOrDefault,
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
									if (occurredOn == 'Invalid date') {
										occurredOn = null
									}
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