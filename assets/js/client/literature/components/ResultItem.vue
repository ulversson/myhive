<template>
	<div class="clearfix search-result">
    <h4>
			<a :href="publicationUrl" target="_blank">
				{{ result.publication_title }}
			</a>
			<small class='text-muted'>{{publicationSummary}}</small>
			<small class='text-muted'
				v-if="result.issue_no">/{{result.issueNo}}</small>
			<small class='text-muted'
				v-if="result.volume">/{{result.volume}}</small>
		</h4>
    <p class="text-success">{{ this.authors }}</p>
		<p> {{ result.abstract }}</p>
		<span class='text-secondary' v-if="tags && tags.length > 0">
			Tags&nbsp;
		</span>
		<a href="javascript:void(0)" v-for="tag in result.tags"
			:key="tag" class='text-info'
			@click="searchTag(tag)">#{{ tag }}&nbsp;</a>
		</p>
		<a class="btn btn-xs btn-outline-danger delete-got-item" 
			data-toggle="tooltip" data-title="Delete item" 
				style="float: right" @click="unpublish"
				v-if="libToken">
      <i class="fal fa-trash-alt"></i>
    </a>
		<a class="btn btn-xs btn-outline-warning edit-got-item mr-2" 
			data-toggle="tooltip" data-title="Edit item" 
				style="float: right" @click="editItem(this)"
				v-if="libToken">
      <i class="fal fa-edit"></i>
    </a>
  </div>
</template>
<script type="text/javascript">
var path = require('path');
  export default {
    props: ['result'],
		methods: {
			editItem() {
				const vm = this
				$.get(this.deleteUrl, (jsonData) =>  {
					vm.form.preload = true
					vm.form.abstract = jsonData.abstract
					vm.form.title = jsonData.publication_title
					vm.form.journal = jsonData.journal
					vm.form.year = jsonData.year.toString(),
					vm.form.issueNo = jsonData.issue_no
					vm.form.volume = jsonData.volume
					const authorTags = jsonData.authors.map((author, index) => {
						if (author.middle_name) {
							vm.form.form.append(`publication[authors][${index}][first_name]`, author.first_name)
							vm.form.form.append(`publication[authors][${index}][middle_name]`, author.middle_name)
							vm.form.form.append(`publication[authors][${index}][last_name]`, author.last_name)
							return {text: `${author.first_name} ${author.middle_name} ${author.last_name}`, 
							"tiClasses":["ti-valid"]}
						} else {
							vm.form.form.append(`publication[authors][${index}][first_name]`, author.first_name)
							vm.form.form.append(`publication[authors][${index}][last_name]`, author.last_name)
							return {text:  `${author.first_name} ${author.last_name}`, "tiClasses":["ti-valid"] }
						}
					})
					const selectedTags = jsonData.tags.map((tag, index) => {
						return {
							text: tag, 
							"tiClasses":["ti-valid"]
						}
					})
					vm.form.authors = authorTags
					vm.form.tags = selectedTags
					vm.form.databaseId = jsonData.database_id
					vm.form.documentName = path.basename(jsonData.document_url)
					vm.index.showForm(true)
				})
			},
			searchTag(tag) {
				const searchTag = tag
				this.$nextTick(() => {
					this.$root.$children[0].$refs.input.query = searchTag
				})
			},
			unpublish() {
				const removeUrl = this.deleteUrl
				 $.ajaxSetup({
					beforeSend: (request) => { 
							request
								.setRequestHeader("X-Auth", 
									`Bearer ${this.libToken}`) 
						}
				})
				UI.runConfirmedAction(
					'fal fa-trash-alt', 
					'DELETE', 
					'Remove library item',
					'This item will be irreversibly removed',
    			removeUrl, 
					() => {
						window.location.reload(true)
					},
				)
			},
		},
    computed: {
			index() {
				return this.$root.$children[0]
			},
			form() {
				return this.index.$refs.form
			},
			deleteUrl() {
				return `${$("div#user-data").data().literatureEndpoint}/publications/${this.result.database_id}`
			},
			libToken() {
				return $("div#user-data").data().literatureToken
			},
      publicationUrl() {
				const endpoint =  $("div#user-data").data().literatureEndpoint
				const docUrl = `${endpoint}/${this.result.document_url}`
				return `${window.location.origin}/web/viewer.html?file=${docUrl}`
      },
      publicationSummary() {
				return `${this.result.journal} - ${this.result.year}`
      },
			tags() {
				return this.result.tags
			},
      authors() {
        return this.result.authors.map(a => `${a.first_name} ${a.last_name}`)
					.join(', ')
      }
    }
  }
</script>