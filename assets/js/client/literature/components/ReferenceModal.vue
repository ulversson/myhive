<template>
	<modal
		name="reference-modal"
		width="40%"
		height="auto"
		:adaptive="true"
		:scrollable="true"
		@before-open="setParams"
		@opened="resetForm"
		styles="font-size: 13px"
		:reset="true">
    <div class="card-header">
      <h4>Insert reference string</h4>
		</div>
		<div class='card-body'>
			  <div class="container h-100">
					<div class="row h-100 justify-content-center align-items-center">
						<form class="col-12">
							<div class="form-group">
								<label class='form-label'>
									Search article
									<span class='required'>*</span>
								</label>
								<div class='pl-0 ml-0 pr-0 mr-0 col-12' style="width: 100% !important">
									<v-select @search="search" 
										:options="options"
										@input="setSelected">
										<template slot="no-options">
        							type to search articles...
      								</template>
											<template v-slot:option="option">
												{{ option.label }}&nbsp;
												<span class='text-muted'>
													{{option.authors_string}} - {{option.year}}
												</span>
											</template>
									</v-select>
								</div>
							</div>
							<div class="form-group" v-if="title">
								<label class='form-label'>
									Page or pages range
								</label>
								<input type='text' class='form-control col-12' v-model="pages" />
								<span class='text-muted'>Leave empty if not needed</span>
							</div>
							<div class="form-group"
								v-if="abstract">
								<label class='form-label'>
									Abstract
								</label>
								<blockquote class='text-muted' 
									style='font-style: italic; text-align: justify; height: 120px; overflow-y: scroll'>
									{{abstract}}
								</blockquote>
							</div>
							<div class="form-group" v-if="document">
								<label class='form-label'>
									Preview (opens in new tab)
								</label>
									<div class='pl-0 ml-0 pr-0 mr-0 col-12' style="width: 100% !important">
										<a :href="documentUrl" class='cui-utils-link-underlined cui-utils-link-blue'
											target="_blank">
											{{title}}
										</a>
									</div>
							</div>
						</form>
					</div>
				</div>
			<div class='buttons pr-0'>
				<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
					style="float: right; margin-right: 0px !important;margin-bottom: 20px !important;"
					@click="hideWindow()">
					<i class="far fa-times-circle"></i>&nbsp;Close
				</a>
				<button class="btn btn-sm btn-primary pull-right mt-2 mr-2"
					style="float: right; margin-bottom: 20px !important;"
					@click="insert()">
					<i class="fal fa-arrow-down"></i>&nbsp;Insert
				</button>
			</div>
		</div>
	</modal>
</template>
<script>
export default {
	data() {
		return {
			options: [],
			page: 1,
			pages: null,
			abstract: '',
			document: null, 
			title: null,
			id: null
		}
	}, 
	computed: {
		searchEndpoint() {
			return $("div#user-data").data().literatureEndpoint
		},
		documentUrl() {
			return `${this.searchEndpoint}/${this.document}`
		}
	},
	methods: {
		setParams(ev) {
      this.$store.commit('updateEditorId', ev.params.name)
		},
		insert() {
			$.ajax({
				type: 'GET',
				url: `${this.searchEndpoint}/publications/${this.id}/reference?pages=${this.pages}`,
			}).done((res) => {
				this.$store.commit('setLastInsertedLiteratureItem', res.data)
				this.$root.$emit('insertReference', res.data)
				this.hideWindow()
			})
		},
		hideWindow() {
			this.$modal.hide('reference-modal')
		},
		setSelected(value) {
			this.abstract = value.abstract
			this.document = value.documentUrl
			this.title = value.label
			this.id = value.id
		},
		resetForm() {
			const reset = {
				abstract: '', 
				document: null,
				pages: null,
				title: null,
				id: null
			}
			this.setSelected(reset)
		},
		search(query, loading) {
			this.options.splice(0, this.options.length)
			$.getJSON(this.searchUrl(query), (jsonRes) => {
				jsonRes.data.forEach((pub, index) => {
					this.options.push({
						label: pub.publication_title,
						year: pub.year,
						authors_string: pub.authors_string,
						id: pub.database_id,
						abstract: pub.abstract,
						documentUrl: pub.document_url
					})
				})
			})
		},
		searchUrl(query) {
			return `${this.searchEndpoint}/publications/search?q=${query}&page=${this.page}`
		},
	}
}
</script>