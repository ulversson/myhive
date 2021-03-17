<template>
	<div class="card position-relative overflow-hidden mb-8">
			<div class="position-absolute bottom-0 left-0 right-0 d-none d-lg-flex flex-row-fluid">
				<span class="svg-icon svg-icon-full flex-row-fluid svg-icon-dark opacity-3">
					<HomeBgSvg />
				</span>
			</div>
			<div class="position-absolute d-flex top-0 right-0 offset-lg-6 col-lg-6 opacity-30 opacity-lg-100">
				<span class="svg-icon svg-icon-full flex-row-fluid p-10">
					<SvgIcon /></SvgIcon>
				</span>
			</div>
			<div class="card-body" style="min-height: 300px">
				<div class="col-lg-6">
					<div class="d-flex align-items-center flex-wrap py-25 px-5">
						<h2 class="text-dark font-weight-bolder mr-12"></h2>
						<SearchInput></SearchInput>
					</div>
				</div>
			</div>
			<SearchResults :results="results"
				v-if="results.length > 0">
			</SearchResults>
		</div>
</template>
<script>
import SearchResults from './components/SearchResults.vue'
import SearchInput from './components/SearchInput.vue'
import HomeBgSvg from './components/HomeBgSvg.vue'
import SvgIcon from './components/SvgIcon.vue'
export default {
	created() {
		this.onSearchStarted()
	},
	data() {
		return {
			results: [], 
			page: 1
		}
	},
	computed: {
		searchEndpoint() {
			return $("div#user-data").data().literatureEndpoint
		}
	},
	methods: {
		searchUrl(query) {
			return `${this.searchEndpoint}/publications/search?q=${query}&page=${this.page}`
		},
		searchRequest(query) {
			this.results.splice(0, this.results.length)
			$.getJSON(this.searchUrl(query), (jsonRes) => {
				jsonRes.forEach((searchRes, index) => {
					this.results.push(searchRes)
				})
			})
		},
		onSearchStarted() {
			this.$root.$on('searchLibrary', (query) => {
				this.searchRequest(query)
			})
		},
	},
	components: {
    SearchResults, SearchInput, HomeBgSvg, SvgIcon 
	}
}
</script>