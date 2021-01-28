<template>
	<modal 
    name="new-report"
    :min-width="750" :min-height="550"
    :adaptive="true" :scrollable="true"
    @opened="resetAll"
    styles="font-size: 13px" :reset="true"
		width="40%" height="auto">
		<div class='card'>
			<div class='card-header'>
				<i class='fal fa-file-medical'></i>&nbsp;
				Report
			</div>
			<div class='card-body'>
				<div class='row'>
					<div class='col-12'>
						<div class="nav-tabs-horizontal reports">
							<ul class="nav nav-tabs mb-4" role="tablist">
								<li class="nav-item">
									<a class="nav-link current active"
										data-toggle="tab" data-target="#new" role="tab">
											<i class='fal fa-file'></i>&nbsp;Current
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link history" 
										data-toggle="tab" data-target="#history" role="tab">
										<i class='fal fa-history'></i>&nbsp;History
									</a>
								</li>
							</ul>
							<div class="tab-content pt-5">
								<div class="tab-pane active" id="new">
									<Form :sections.sync="sections" 
										:template="template"
										:textColor="textColor"
										ref="form"
										:buttonDisabled.sync="buttonDisabled" />
								</div>
								<div class="tab-pane" id="history">
									<HistoryTab ref="history" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</modal>
</template>
<script>
import Form from './Form.vue'
import HistoryTab from './HistoryTab.vue'
import settings from '../../file_manager/mixins/settings'
export default {
	mixins: [settings],
	props: ['textColor'],
	created() {
		this.onTemplateSelected()
	},
	methods: {
		hideModal() {
			this.$modal.hide('new-report')
		},
		onTemplateSelected() {
			this.$root.$on('selectedTemplate', (template) => {
				this.template = template
			})
		},
		resetAll() {
			this.$refs.form.reset()
		}
	},
	data() {
		return {
			template: null
		}
	},
	computed: {
		buttonDisabled() {
			return this.template === null || this.template === undefined
		},
		sections() {
			if (this.template === null) {
				return []
			} else {
				return this.template.sections
			}
		}
	},
	components: {
		Form, HistoryTab		
	}
}
</script>