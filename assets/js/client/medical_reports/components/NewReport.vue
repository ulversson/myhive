<template>
	<modal 
    name="new-report"
    :min-height="550"
    :adaptive="true" :scrollable="true"
    @opened="resetAll"
    @closed="clearAutosave"
    styles="font-size: 13px" :reset="true"
		width="850" height="auto">
		<div class='card'>
			<div class='card-header'>
				<i class='fal fa-file-medical'></i>&nbsp;
				Report - last saved: 
				<span class='saved' v-html="lastSaved"></span>
			</div>
			<div class='card-body'>
				<div class='row'>
					<div class='col-12'>
						<div class="nav-tabs-horizontal reports">
							<ul class="nav nav-tabs reports mb-4" role="tablist">
								<li class="nav-item reports">
									<a class="nav-link reports current active"
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
										:isAdmin="isAdmin"
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
	props: ['textColor','isAdmin'],
	created() {
		this.onTemplateSelected()
		this.onLastUpdatedDate()
	},
	 beforeDestroy(){
    this.clearAutosave()
  },
	methods: {
		onLastUpdatedDate() {
			this.$root.$on('setUpdatedDate', (date) => {
				this.lastUpdatedDate = date
			})
		},
		clearAutosave() { 
			if (window.intervalToken) {
				clearInterval(window.intervalToken)
				window.intervalToken = null
			}
			if (window.refreshToken) {
				clearInterval(window.refreshToken)
				window.refreshToken = null
			}
		},
		hideModal() {
			this.clearAutosave()
			this.$modal.hide('new-report')
		},
		onTemplateSelected() {
			this.$root.$on('selectedTemplate', (template) => {
				this.template = template
				if (this.$refs.form) this.$refs.form.clearSkipped()
				this.saveEveryXSeconds()
			})
		},
		saveEveryXSeconds() {
			let vm
			if (window.intervalToken) return
			window.intervalToken = setInterval(() => {
				this.$refs.form.autosave()
			}, 240000) //4 min in ms 
			window.refreshToken = setInterval(() => {
				if (this.lastUpdatedDate) {
					this.$root.$emit('setUpdatedDate', moment(this.lastUpdatedDate).add(1, 'seconds'))
				}
			}, 10000) // every 10 sec
		},
		resetAll() {
			this.$refs.form.reset()
			this.saveEveryXSeconds()
		}
	},
	data() {
		return {
			template: null,
			lastUpdatedDate: null,
			tick: 0
		}
	},
	computed: {
		lastSaved() {
			if (!this.lastUpdatedDate) {
				return "<span class='badge badge-pill badge-danger'>not saved yet</span>"
			} else {
				try {
					const date = moment(this.lastUpdatedDate).fromNow()
					return  `<span class='badge badge-pill badge-info'>${date}</span>`
				} catch(e) {
					return `<span class='badge badge-pill badge-danger'>not saved yet</span>`
				}
				
			}
		},
		buttonDisabled() {
			return this.template === null || this.template === undefined
		},
		sections() {
			if (this.template === null) {
				return []
			} else {
				return this.template.report_sections.map(rs => rs.report_section)
			}
		}
	},
	components: {
		Form, HistoryTab		
	}
}
</script>