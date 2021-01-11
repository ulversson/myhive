<template>
	<div class='timeline-container pt-5 pr-3' :id="`#t${timelineId}`">
    <Timeline :statuses.sync="orderedStatuses" 
      :completed.sync="completed"
      :isAdmin="isAdmin"
      :started.sync="started"
			:showOnInit="showOnInit"
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