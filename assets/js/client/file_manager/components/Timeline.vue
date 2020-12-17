<template>
  <div class="col-md-12" style="overflow-y: scroll; height: 600px">
    <div class="main-timeline">
      <TimelineItem
        :status="status"
        :isAmin="isAdmin"
        v-for="status in statuses"
        :key="status.id"
      />
    </div>
  </div>
</template>
<script>
import TimelineItem from "./timeline/TimelineItem.vue";
export default {
  props: ["statuses", "completed", "started", "isAdmin"],
  components: { TimelineItem },
  mounted() {
    this.scrollToLastCompleted()
  },
  created() {
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
        let cmpIdx = this.completed.indexOf(stage.order);
        if (cmpIdx !== -1) {
          this.completed.splice(cmpIdx, 1);
        }
        let startIdx = this.started.indexOf(stage.order);
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