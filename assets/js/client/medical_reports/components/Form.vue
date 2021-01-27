<template>
	<div class='form'>
		<TemplateSelect ref="template" />
		<OutgoingEmailStorage 
			:textColor="textColor" 
			:preselect="'Medical Reports'"
			:label="'Save generated report in'"
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
export default {
	props: ['sections', 'textColor', 'buttonDisabled', 'template'],
	components: {
		TemplateSelect, Editor, OutgoingEmailStorage, ReportButtons
	},
	methods: {
		saveSections(saveDocument = true) {
			return $.ajax({
				type: 'POST',
				url: `/api/v1/reports/${this.template.id}/save_sections?save_doc=${saveDocument}`,
				data: this.formData
			})
		}
	},
	computed: {
		formData() {
			return {
				report: {
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
		}
	}
}
</script>
