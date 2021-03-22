<template>
	<div class="card-body">
    <div id="content" class="container">
      <div class="panel panel-default">
        <div class="panel-body" v-if="results.length > 0">
          <h6 class="nomargin"> 
            About {{totalEntries}} results 
						<small class="text-success">
							({{secondsTime}} seconds) 
						</small>
          </h6>
          <hr class="nomargin-bottom margin-top-10">
					<result-item 
						v-for="result in results" :key="result.id"
            :result.sync="result" />
				</div>
			</div>
		</div>
	</div>
</template>
<script>
import ResultItem from './ResultItem.vue'
export default {
	props: ['results'],
	components: { ResultItem },
	computed: {
		secondsTime() {
			return parseFloat(this.responseTime / 1000).toFixed(2)

		}
	},
	data() {
		return {
			responseTime: 0,
			pageNumber: 1, 
			pageSize: 0,
			totalEntries: 0,
			totalPages: 0
		}
	},
	created() {
		this.addMeta()
	},
	methods: {
		addMeta() {
			this.$root.$on('searchDone', (data) => {
				this.pageNumber = data.response.page_number
				this.pageSize  = data.response.page_size
				this.totalEntries = data.response.total_entries
				this.totalPages = data.response.total_pages,
				this.responseTime = data.time
			})	
		}
	}
}
</script>