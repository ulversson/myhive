<template>
  <div class='timeline'
    :class="[
      isStartedStage ? 'started' : '',
      isCompletedStage ? 'completed' : ''
    ]">
    <a href="#" class="timeline-content card" 
      :data-order="status.order">
      <div class="timeline-icon"
        @click="nextStatus">
        <i :class="status.icon"></i>
      </div>
      <h3 class="title">{{ status.name }}</h3>
      <p class="description">
        <span
          v-if="isNotStartedStage"> 
            Stage not started yet 
        </span>
        <span
          v-if="isStartedStage"> 
            Started at {{ formattedStartDate }} by 
            <span class='badge badge-pill badge-secondary'
              style="font-size: 13px">
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
      </p>
    </a>
  </div>
</template>
<script>
export default {
  props: ['status'],
  created() {
    this.$root.$on('caseStatusChanged', (stage) => {
      if (stage.id === this.status.id) {
        if (this.isStarted(stage)) {
          this.completeStage(stage)
        } else if (this.isCompleted(stage)) {
          this.restartStage(stage)
        } else if (this.isStageNotStarted(stage)) {
          this.startStage(stage)
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
        this.$parent.startStage(status)
      } else {
        let idx = this.$parent.completed.indexOf(status.order-1)
        if (idx !== -1) {
          this.$parent.startStage(status)
        } else {
          this.$root.$emit('stageStartError', status)
       }
      }
    },
    completeStage(status) {
      if (status.order === 1) {
        this.$parent.completeStage(status)
      } else {
        let idx = this.$parent.started.indexOf(status.order)
        let idx2 = this.$parent.completed.indexOf(status.order-1)
        if (idx !== -1 && idx2 !== -1) {
        this.$parent.completeStage(status)
        } else {
          this.$root.$emit('stageCompleteError', status)
        }
      }
    },
    restartStage(status) {
      let greater = this.$parent.completed.filter(it => it > status.order)
      if (greater.length === 0) {
        this.$parent.removeStage(status)
      } else {
        this.$root.$emit('stageRemoveError', status)
      }
    },
    nextStatus() {
      this.$root.$emit('caseStatusChanged', this.status)
    }
  },
  computed: {
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
    }
  }
}
</script>