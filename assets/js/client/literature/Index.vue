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
				<a class="btn btn btn-myhive active mt-4" 
					title="Add new literature entry"
					data-toggle="tooltip"
					@click="showForm(false)"
					id='add-new-case'>
					<i class="fal fa-plus"></i>
					&nbsp;<span class='font-size-14 text'>Add new entry</span>
				</a >
				<div class="d-flex align-items-center flex-wrap py-25 px-5" 
					style="padding-left: 0.65rem !important;">
					<h2 class="text-dark font-weight-bolder mr-12"></h2>
					<SearchInput ref="input"></SearchInput>
				</div>
			</div>
		</div>
		<SearchResults :results.sync="results"
			v-show="!searching" 
			ref="results">
		</SearchResults>
		<Form ref="form"></Form>
	</div>
</template>
<script>
import SearchResults from './components/SearchResults.vue'
import SearchInput from './components/SearchInput.vue'
import HomeBgSvg from './components/HomeBgSvg.vue'
import SvgIcon from './components/SvgIcon.vue'
import Form from './components/Form.vue'
export default {
	created() {
		this.onSearchStarted()
	},
	data() {
		return {
			searching: false,
			results: [], 
			page: 1
		}
	},
	computed: {
		searchEndpoint() {
			return $("div#user-data").data().literatureEndpoint
		},
	},
	methods: {
		showForm(preload = false) {
			this.$refs.form.preload = preload
			this.$modal.show('literature-modal')
		},
		searchUrl(query) {
			return `${this.searchEndpoint}/publications/search?q=${query}&page=${this.page}`
		},
		searchRequest(query) {
			this.searching = true
			this.results.splice(0, this.results.length)
			const t0 = performance.now()
			$.getJSON(this.searchUrl(query), (jsonRes) => {
				jsonRes.data.forEach((searchRes, index) => {
					this.results.push(searchRes)
				})
				const t1 = performance.now()
				this.$root.$emit('searchDone', {
					time: (t1-t0), response: jsonRes
				})
				this.searching = false
			})
		},
		onSearchStarted() {
			this.$root.$on('searchLibrary', (query) => {
				this.searchRequest(query)
			})
		},
	},
	components: {
    SearchResults, SearchInput, HomeBgSvg, SvgIcon, Form
	}
}
</script>