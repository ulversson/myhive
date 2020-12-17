<template>
  <div class="col-md-12" style="overflow-y: scroll; height: 600px">
    <div class="main-timeline">
      <TimelineItem
        :status="status"
        v-for="status in statuses"
        :key="status.id"
      />
    </div>
  </div>
</template>
<script>
import TimelineItem from "./timeline/TimelineItem.vue";
export default {
  props: ["statuses", "completed", "started"],
  components: { TimelineItem },
  methods: {
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
      debugger;
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        this.started.push(dbstage.order);
      });
    },
    completeStage(stage) {
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        this.completed.push(stage.order);
      });
    },
    removeStage(stage) {
      this.requestStatusChange(stage).done((dbstage) => {
        this.$root.$emit("updateStage", dbstage);
        let cmpIdx = this.completedStages.indexOf(stage.order);
        if (cmpIdx !== -1) {
          this.completed.splice(cmpIdx, 1);
        }
        let startIdx = this.startedStages.indexOf(stage.order);
        if (startIdx !== -1) {
          this.started.splice(startIdx, 1);
        }
      })
    }
  }
}
</script>