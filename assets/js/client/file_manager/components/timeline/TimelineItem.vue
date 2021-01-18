<template>
  <div class='timeline'
    :class="[
      isStartedStage ? 'started' : '',
      isCompletedStage ? 'completed' : ''
    ]">
    <a href="#" class="timeline-content card" 
      :data-order="status.order">
      <div class="timeline-icon" style="cursor: hand"
      	@click="nextStatus">
        <i :class="status.icon"></i>
      </div>
      <h3 class="title">
				<quick-edit v-model="status.name" 
					@input="saveName"
					:classes="vueQuickEditClasses"></quick-edit>
			</h3>
      <p class="description">
        <span
          v-if="isNotStartedStage">
						Stage not started
					</span>
        <span
          v-if="isStartedStage"> 
            Started at {{ formattedStartDate }} by 
            <span class='badge badge-pill badge-secondary'
              style="font-size: 10px">
              {{ status.started_name }}
            </span>
        </span>
        <span
          v-if="isCompletedStage"> 
            Completed at {{ formattedStartDate }} by 
            <span class='badge badge-pill badge-secondary' 
              style="font-size: 13px">
              {{ status.completed_name }}
            </span>
        </span>
				<div class='buttons' style='margin: auto'
					v-if="isAdmin">
					<button class="btn btn-icon btn-xs btn-rounded btn-outline-danger mt-2 ml-2 pull-right"
						style="opacity: 0.6"
						data-toggle='tooltip' 
						@click="removeTimelineItem()"
						data-title='Remove timeline item'>
						<i class="fas fa-trash-alt"></i>
        	</button>
					<a class="btn btn-icon btn-xs btn-rounded btn-outline-success mt-2 ml-2 pull-right"
						style="opacity: 0.6"
						data-toggle='tooltip' 
						@click="showComments()"
						data-title='Remove timeline item'>
						<i class="fas fa-comments"></i>
        	</a>
					<span class="badge badge-success" v-if="status.comments_count > 0"
						style="font-size: 13px; opacity: 0.6">
						{{ status.comments_count }}
					</span>
				</div>
      </p>
    </a>
		<Comments :status="status"/>
  </div>
</template>
<script>
// @ts-nocheck
import moment from 'moment'
import QuickEdit from 'vue-quick-edit'
import Comments from './comments/Comments.vue'
export default {
	props: ['status', 'isAdmin'],
	data() {
		return {
			vueQuickEditClasses: {
				wrapper: '',
				input: 'form-control input-sm',
				buttons: 'btn-group btn-group-sm',
				buttonOk: 'btn btn-myhive mr-3',
				buttonCancel: 'btn btn-secondary mr-3',
			}
		}
	},
  created() {
    this.$root.$on('caseStatusChanged', (stage) => {
      if (stage.status.id === this.status.id) {
        if (this.isStarted(stage.status)) {
          this.completeStage(stage.status)
        } else if (this.isCompleted(stage.status)) {
          this.restartStage(stage.status)
        } else if (this.isStageNotStarted(stage.status)) {
          this.startStage(stage.status)
				}
      }
    })
    this.$root.$on('updateStage', (stage) => {
      if (stage.id === this.status.id) {
        this.$set(this, 'status', stage)
      }
    })
  },
  methods: {
		showComments() {
			this.$modal.show(`comments-modal-${this.status.id}`)
		},
		removeTimelineItem() {
      UI.runConfirmedAction(
        'fas fa-trash-alt', 
        'DELETE',
        'Remove this timeline item',
        'The progress for this case will be recalculated',
        `/api/v1/timeline/${this.status.id}`, () => {
          window.location.reload(true)
        }
      )
    },
		saveName(name) {
			$.ajax({
				url: `/api/v1/timeline/${this.status.id}/name`,
				type: 'PATCH',
				data: {id: this.status.id, name: name}
			})
		},
    isStarted(status) {
      return status.started_at !== null && status.completed_at === null
    },
    isCompleted(status) {
      return status.started_at !== null && status.completed_at !== null
    },
    isStageNotStarted(status) {
      return status.started_at === null && status.completed_at === null
    },
    startStage(status) {
      if (status.order === 1) {
        this.timeline.startStage(status)
      } else {
        let idx = this.timeline.completed.indexOf(status.order-1)
        if (idx !== -1) {
          this.timeline.startStage(status)
        } else {
          this.$root.$emit('stageStartError', status)
       }
      }
    },
    completeStage(status) {
      if (status.order === 1) {
        this.timeline.completeStage(status)
      } else {
        let idx = this.timeline.started.indexOf(status.order)
        let idx2 = this.timeline.completed.indexOf(status.order-1)
        if (idx !== -1 && idx2 !== -1) {
        this.timeline.completeStage(status)
        } else {
          this.$root.$emit('stageCompleteError', status)
        }
      }
    },
    restartStage(status) {
      let greater = this.timeline.completed.filter(it => it > status.order)
      if (greater.length === 0) {
        this.timeline.removeStage(status)
      } else {
        this.$root.$emit('stageRemoveError', status)
      }
    },
    nextStatus() {
      if (this.isAdmin) {
        this.$root.$emit('caseStatusChanged', {
          status: this.status, 
          sum: Math.round(this.mainTimeline.totalSum(), 2).toFixed(2)
				})
      }
    }
  },
  computed: {
		mainTimeline() {
			return this.$root.$children[0].$refs.timeline
		},
		timeline() {
			return this.mainTimeline.$refs.timeline
		},
    formattedStartDate() {
      return moment(this.status.started_at)
        .format('DD/MM/YYYY HH:mm')
        
    },
    formattedCompletedDate() {
      return moment(this.status.completed_at)
        .format('DD/MM/YYYY HH:mm')
       
    },
    isStartedStage() {
      return this.status.started_at !== null && this.status.completed_at === null
    },
    isCompletedStage() {
      return this.status.started_at !== null && this.status.completed_at !== null
    },
    isNotStartedStage() {
      return this.status.started_at === null && this.status.completed_at === null
		},
	},
	components: { QuickEdit, Comments }
}
</script>

<style>
.vue-quick-edit__link--is-clickable {
  color: white !important;
	cursor: pointer;
	border-bottom: none !important;
	font-weight: normal;
}
.vue-quick-edit__link {
    white-space: pre-wrap !important;
    color: white;
}
</style>