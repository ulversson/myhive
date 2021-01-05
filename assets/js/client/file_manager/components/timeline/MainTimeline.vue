<template>
	<div class='timeline-container' :id="`#t${timelineId}`">
    <Timeline :statuses.sync="orderedStatuses" 
      :completed.sync="completed"
      :isAdmin="isAdmin"
      :started.sync="started"
    ref="timeline" />
  </div>
</template>
<script>
import Timeline from './Timeline.vue'
import caseStatus from '../../mixins/caseStatus'
export default {
	props: ['timelineId', 'showOnInit', 'isAdmin'],
	components: { Timeline  },
	mixins: [ caseStatus ],
	created() {
		this.loadCaseStatuses()
	}
}
</script>