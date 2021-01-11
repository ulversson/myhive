<template>
  <div class="col-md-12" style="overflow-y: scroll; height: 600px">
    <div class="main-timeline">
			<h4 class='text-center'>Case Progress</h4>
			<StageActions v-if="isAdmin" />
			<div class='row'>
				<ProgressKnob 
					:showKnobOnInit="showOnInit" :knobValue="progress" />
			</div>
			<draggable v-model="items"
				@start="drag = true"
				handle=".timeline-icon"
				:sort="true"
				:animation="200"
				@end="drag = false"
				@update.prevent="updateList">
    		<transition-group 
					type="transition" :name="!drag ? 'flip-list' : null">
					<TimelineItem
						:status="status"
						:isAdmin="isAdmin"
						v-for="status in items"
						:key="status.id"/>
				</transition-group>
			</draggable>
    </div>
  </div>
</template>
<script>
// @ts-nocheck
import draggable from 'vuedraggable';
import TimelineItem from "./TimelineItem.vue"
import StageActions from './StageActions.vue'
import ProgressKnob from './ProgressKnob.vue'
export default {
  props: ["statuses", "completed", "started", "isAdmin", "showOnInit"],
	components: { draggable, TimelineItem, StageActions, ProgressKnob },
	data() {
		return {
			drag: false,
			requestItems: []
		}
	},
	computed: {
		progress() {
			return this.$root.$children[0].progress
		},
		items: {
			  get() {
          return this.$store.state.medicoLegalCaseStatuses
        },
        set(value) {
					this.$emit('updateList', value)
        }
		},

	},
  mounted() {
    this.scrollToLastCompleted()
	},
  created() {
		this.$on('updateList', (data) => {
			this.updateList(data)
		})
    this.$root.$on('stageStartError', (status) => {
      this.$swal(
        'Error', 
        `Unable to move case to  '${status.name}' status. Make sure all previous statuses are completed - green.`,
        'error'
      )
    })
    this.$root.$on('stageCompleteError', (status) => {
      this.$swal(
        'Error', 
        `Unable to move case to  '${status.name}' status. Make sure all previous statuses are completed - green.`,
        'error'
      )
    })
    this.$root.$on('stageRemoveError', (status) => {
      this.$swal(
        'Error', 
        `Unable to move case to the previous state '${status.name}'. Make sure you reverse their statuses one by one without skipping steps`,
        'error'
      )
    })
  },
  methods: {
		updateList(newList) {
			if (newList.length > 0 ) {
				this.updateStatuses(newList)
			}
 	
		},
		updateStatuses(newList) {
			let vm = this
			let mlcId = window.localStorage.getItem('currentMedicoLegalCaseId')
			$.ajax({
				url: `/api/v1/timeline/${mlcId}`,
				data: {statuses: newList},
				type: 'PATCH'
			}).done((jsRes) => {
				window.location.reload(true)
			})
		},
    scrollToLastCompleted() {
      this.$nextTick(function () {
      let lastCompletedStep = $("div.timeline.completed:last")[0]
        if (lastCompletedStep) {
          lastCompletedStep.scrollIntoView(true)
        }
      })
    },
    nextStatusUrl(status) {
      return `/api/v1/medico_legal_cases/${status.medico_legal_case_id}/next/${status.id}`;
    },
    requestStatusChange(status) {
      return $.ajax({
        type: "PATCH",
        url: this.nextStatusUrl(status),
      });
    },
    startStage(stage) {
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        this.started.push(dbstage.order);
        let statusIdx = this.statuses.findIndex(s => s.id == stage.id)
        this.statuses.splice(statusIdx, 1, dbstage)
				this.$parent.updateSum()
      });
    },
    completeStage(stage) {
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        this.completed.push(stage.order);
        let statusIdx = this.statuses.findIndex(s => s.id == stage.id)
        this.statuses.splice(statusIdx, 1, dbstage)
        this.$parent.updateSum()
      });
    },
    removeStage(stage) {
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        let cmpIdx = this.completed.indexOf(stage.order)
        if (cmpIdx !== -1) {
          this.completed.splice(cmpIdx, 1)
        }
        let startIdx = this.started.indexOf(stage.order)
        if (startIdx !== -1) {
          this.started.splice(startIdx, 1);
        }
        let statusIdx = this.statuses.findIndex(s => s.id == stage.id)
        this.statuses.splice(statusIdx, 1, dbstage)
        this.$parent.updateSum()
      })
    }
  }
}
</script>