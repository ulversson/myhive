<template>
	<div class="card-body">
    <div id="content" class="container">
      <div class="panel panel-default">
        <div class="panel-body">
          <h6 class="nomargin"> 
            About 1,280 results <small class="text-success">(0.45 seconds) </small>
          </h6>
          <hr class="nomargin-bottom margin-top-10">
					<result-item 
						v-for="result in results" :key="result.id"
            :result="result" />
				</div>
			</div>
		</div>
	</div>
</template>
<script>
import ResultItem from './ResultItem.vue'
export default {
	props: ['results'],
	components: { ResultItem }
}
</script>