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
			<div class='form-group' 
				v-for="(sec, idx) in sections" :key="sec.id"> 
				<label>{{ sec.name }}</label>
			<Editor :name="`editor-${sec.id}-${idx}`"
				:ref="`editor-${idx}`"
				:sectionId="sec.id"
				:templateId="template ? template.id : null"
			 />
		</div>
		<ReportButtons 
			ref="buttons"
			:isButtonDisabled.sync="buttonDisabled" />
	</div>
</template>
<script>
import TemplateSelect from './TemplateSelect.vue'
import Editor from './Editor.vue'
import ReportButtons from './ReportButtons.vue'
import OutgoingEmailStorage from '../../file_manager/components/email_templates/send/OutgoingEmailStorage.vue'
import UserSelect from './UserSelect.vue'
import folderTree from '../../file_manager/mixins/folderTree'
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
		TemplateSelect, Editor, OutgoingEmailStorage, 
		ReportButtons, UserSelect
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
			let report = {
				report: {
					user_id: this.selectedUser,
					folder_id: this.$refs.storage.selectedValue, 
					medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
					report_template_id: this.template.id,
					report_template_sections: this.sections.map((s, idx) => {
						return {
							report_template_id: this.template.id,
							report_section_id: s.id,
							report_template_section_id: this.template.report_sections[idx].id,
							content: this.$refs[`editor-${idx}`][0].body()
						}
					})
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
