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
			:isButtonDisabled.sync="buttonDisabled"
			v-if="!buttonDisabled" />
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
				const firstRow = Object.keys(this.historyTab.$refs)[0]
				if (firstRow) {
					const loadButton = Object.keys(this.historyTab.$refs[firstRow][0].$refs)[0]
					if (loadButton) {
						this.historyTab.$refs[firstRow][0].$refs[loadButton].loadSections(newDraft)
					}
				}
				//["row-199"][0].$refs["action-199"].loadSections(newDraft)
			}
		}
	},
	data() {
		return {
			lastSaved: 'not saved yet',
			draftReport: {},
			isLoaded: false, 
			reportId: null,
			taggable_ids: [],
			skippedSections: [],
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
		 isNotSkipped(sectionId) {
       return this.skippedSections.indexOf(sectionId) === -1
     },
     addRemoveSkipped(sectionId) {
        if (this.isNotSkipped(sectionId)) {
        	$(`div.editor[data-id=${sectionId}]`).css('style', 'opacity: 0.4')
          this.skippedSections.push(sectionId)
        } else {
        	$(`div.editor[data-id=${sectionId}]`).css('style', 'opacity: 1')
          const idx = this.skippedSections.indexOf(sectionId) 
          this.skippedSections.splice(idx, 1)
        }
     },
		formData() {
			this.taggable_ids.splice(0, this.taggable_ids.length)
			const groupedBySectionId = Fn.groupMapsByKey(this.template.report_sections, 'report_section_id')
			const report = {
				report: {
					user_id: this.userOrDefault,
					folder_id: this.$refs.storage.selectedValue, 
					medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
					report_template_id: this.template.id,
					report_template_sections: this.buildFormSectionsData(groupedBySectionId)
			}
		}
		if (this.reportId) {
			report.report["id"] = this.reportId
		}
		if (this.taggable_ids.length > 0) {
			report.report["taggable_ids"] = this.taggable_ids
		}
		return report
		},
		buildFormSectionsData(formDataArray) {
			return Object.keys(formDataArray).map((seId) => {
				const items = formDataArray[seId]
					return items.map((s, idx) => {
						let se = s.report_section
						let sectionPanel = this.$refs.tabs.$refs[`editor-${se.id}`][0]
						if (sectionPanel.isTaggable) {
							sectionPanel.items.forEach((i) =>  {
								return this.taggable_ids.push({
									id: i.value, 
									content: sectionPanel.$refs[`tag-${i.id}`][0].content
								})
							})
						} else {
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
							order: items.indexOf(s)+1,
							is_skipped: !this.isNotSkipped(se.id),
							taggableIds: this.taggableIds,
							report_template_section_id: this.template.report_sections[idx].id,
							content: editor.body()
						}
						})
					}
					})//map
				})//map2
		},
		clearAutosave() {
			if (window.intervalToken) {
				clearInterval(window.intervalToken)
				window.intervalToken = null
			}
		},
		saveFormLocally() {
			if (this.$refs.curentForm.dataset.id.length === 0) {
				this.$refs.curentForm.dataset.id = Fn.randomString() 
			} 
		},
		autosave() {
			if (this.template && this.userOrDefault) {
				return $.ajax({
					type: 'POST', 
					url: `/api/v1/reports/${this.$refs.curentForm.dataset.id}/draft`, 
					data: this.formData()
				}).done((rep) => {
					this.$root.$emit('setUpdatedDate', rep.updated_at)
				}) 
			} else {
				console.log('Data missing')
			}		
		},
		loadDraft() {
			if (!this.template || !this.userOrDefault) return 
			const caseId = window.localStorage.getItem('currentMedicoLegalCaseId')
			return $.ajax({
				type: 'GET', 
				url: `/api/v1/reports/load_draft/${caseId}/${this.userOrDefault}/${this.template.id}`
			}).done((res) => {
				this.draftReport = res
				this.$root.$emit('setUpdatedDate', res.updated_at)
			})
		},
		hasErrors() {
			if (this.isAdmin) {
				return  this.$refs.userSelect.hasSelectError || this.$refs.storage.hasError() 
			} else {
				return this.$refs.storage.hasError() 
			}
		},
		clearSkipped() {
			if (this.skippedSections.length > 0) {
				this.skippedSections.splice(0, this.skippedSections.length)
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
			this.$root.$emit('setUpdatedDate', null)
			this.clearSkipped()
			$("button.vs__clear").click()
			this.clearAutosave()
		},
		saveSections(saveDocument = true) {
			return $.ajax({
				type: this.isLoaded ? 'PATCH' : 'POST',
				url: `/api/v1/reports/${this.template.id}/save_sections?save_doc=${saveDocument}`,
				data: this.formData()
			})
		}
	},
	computed: {
		draftLoaded() {
			return Object.keys(this.draftReport).length > 0
		},
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
		historyTab() {
			return this.$parent.$parent.$refs.history
		}
	}
}
</script>