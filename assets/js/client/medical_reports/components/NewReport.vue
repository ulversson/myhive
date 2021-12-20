<template>
	<modal 
    name="new-report"
    :min-height="550"
    :adaptive="true" :scrollable="true"
		v-bind:click-to-close="false"
    @opened="resetAll"
    @closed="clearAutosave"
    styles="font-size: 13px" :reset="true"
		width="850" height="auto">
		<div class='card'>
			<div class='card-header'>
				<i class='fal fa-file-medical' style="vertical-align: text-bottom; font-size: 11px;"></i>&nbsp;
				<span class='text-secondary saved' style='margin-bottom: -4px; display:inline-block; vertical-align: text-top'>
					Document - last saved: 
				</span>
				<span class='saved' v-html="lastSaved"></span>
				<span class='text-secondary' style='vertical-align: sub;'>
					Document will be saved in:&nbsp;
				</span>
				<span class='will-save text-secondary' style='vertical-align: sub;'></span>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"
					@click="hideModal()">
        <span aria-hidden="true">&times;</span>
      </button>
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
									<a class="nav-link reports" 
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
								<LiteratureForm ref='literature-form'></LiteratureForm>
								<ReferenceModal ref='reference-modal'></ReferenceModal>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</modal>
</template>
<script>
import Fn from '../../../functions'
import Form from './Form.vue'
import LiteratureForm from '../../literature/components/Form.vue'
import ReferenceModal from '../../literature/components/ReferenceModal.vue'
import HistoryTab from './HistoryTab.vue'
import settings from '../../file_manager/mixins/settings'
import modalOperations from '../mixins/modalOperations'
export default {
	mixins: [settings, modalOperations],
	props: ['textColor','isAdmin'],
	created() {
		this.onTemplateSelected()
		this.onLastUpdatedDate()
		//this.countdownSave()
	},
	 beforeDestroy(){
    this.clearAutosave()
		this.clearCountdown()
  },
	methods: {
		onLastUpdatedDate() {
			this.$root.$on('setUpdatedDate', (date) => {
				this.lastUpdatedDate = date
			})
			this.$root.$on('resetcountdown', (clear) =>  {
				this.countdownSave()
				if (clear) this.clearCountdown()
			})
		},
		onTemplateSelected() {
			this.$root.$on('selectedTemplate', (template) => {
				console.log(template)
				this.template = template
				if (this.$refs.form) this.$refs.form.clearSkipped()
				this.saveEveryXSeconds()
				if  (this.template) this.countdownSave()
			})
		},
		saveEveryXSeconds() {
			let vm
			if (window.intervalToken) return
			window.intervalToken = setInterval(() => {
				this.$refs.form.autosave()
				if (window.countdown) clearInterval(window.countdown)
				this.countdownSave()
			}, 240000) //4 min in ms 
			window.refreshToken = setInterval(() => {
				if (this.lastUpdatedDate) {
					this.$root.$emit('setUpdatedDate', moment(this.lastUpdatedDate).add(1, 'seconds'))
				}
			}, 10000) // every 10 sec
		},
		resetAll() {
			this.$refs.form.reset()
			this.clearCountdown()
			this.saveEveryXSeconds()
		},
		clearCountdown() {
			clearInterval(window.countdown)
			window.countdown = null
			$('span.will-save').html('')
		},
		countdownSave() {
			if (window.countdown) clearInterval(window.countdown)
			window.countdown = null
		  if (!window.countdown) {
				const fourMins = 4 * 60;
      	const display = document.querySelector('span.will-save')
				Fn.countdownToTime(fourMins, display)
			}
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
				return "&nbsp;<span class='badge badge-pill badge-danger' style='padding-top: 2px; vertical-align:baseline'>not saved yet</span>"
			} else {
				try {
					const date = moment(this.lastUpdatedDate).fromNow()
					return  `&nbsp;<span class='badge badge-pill badge-info' style='padding-top: 2px;vertical-align:baseline'>${date}</span>`
				} catch(e) {
					return `&nbsp;<span class='badge badge-pill badge-danger' style='padding-top: 2px;'>not saved yet</span>`
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
		Form, HistoryTab, LiteratureForm, ReferenceModal		
	}
}
</script>