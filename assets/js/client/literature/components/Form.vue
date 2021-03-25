<template>
	<div class='literature-modals' style="max-height: 600px; overflow-y: scroll">
    <div class="vld-parent">
      <loading :active.sync="loading" 
        :can-cancel="false" 
        :is-full-page="true">  
      </loading>
    </div>  
    <modal
			name="literature-modal"
			width="40%"
			height="auto"
			:adaptive="true"
			:scrollable="true"
			@opened="resetForm"
			@before-open="setParams"
			styles="font-size: 13px"
			:reset="true">
    <div class="card-header">
      <h4>{{ preload ?  'Edit' : 'Add'}}&nbsp;literature entry</h4>
			  <div class="container h-100">
					<div class="row h-100 justify-content-center align-items-center">
						<form class="col-12">
							<div class="form-group">
								<label class='form-label'>
									Publication title
									<span class='required'>*</span>
								</label>
								<input type="text" class="form-control" 
									:class=" hasError('publication_title') ? 'is-invalid' : ''"
									placeholder="Please enter publication title..."
									v-model="title">
								<span class='invalid-feedback'
									:class=" hasError('publication_title') ? 'is-invalid' : ''">
									{{ errorMessage('publication_title') }}
								</span>
							</div>
							<div class="form-group">
								<label class='form-label'>
									Abstract (optional)
								</label>
								<textarea class="form-control" rows="4" style="resize: none"
									v-model="abstract">
								</textarea>
							</div>
							<div class="form-group authors"
								:class=" hasError('authors') ? 'is-invalid' : ''">
								<label class='form-label'>
									Authors
									<span class='required'>*</span>
								</label>
								<vue-tags-input
									v-model="author"
									:tags="authors"
									:allow-edit-tags="true"
									:avoid-adding-duplicates="true"
									@before-deleting-tag="deleteAuthor"
									:class=" hasError('authors') ? 'is-invalid' : ''"
									@before-adding-tag="addAuthor"
									:placeholder="'Add publication authors'"
									:add-from-paste="false"
									@tags-changed="addAuthor"/>
							</div>
							<span class='invalid-feedback'
								:class=" hasError('authors') ? 'is-invalid' : ''">
								{{ errorMessage('authors') }}
							</span>
							<div class="form-group">
								<label class='form-label'>
									PDF Document
									<span class='required'>*</span>
								</label>
								<div class="input-group mb-3"
									v-if="!preload"
									:class=" hasError('document') ? 'is-invalid' : ''">
									<div class="custom-file">
										<input type="file" class="custom-file-input form-control" 
											:class=" hasError('document') ? 'is-invalid' : ''"
											accept="application/pdf"
											@change="onChangeFile">
										<label class="custom-file-label" 
											v-model="document">{{ fileLabel }}</label>
									</div>
									<span class='invalid-feedback'
										:class=" hasError('document') ? 'is-invalid' : ''">
										{{ errorMessage('document') }}
									</span>
								</div>
								<div class="input-group mb-3"
									v-if="preload">
									<div class="custom-file">
										<label class="custom-file-label" 
											v-model="document">{{ fileLabel }}</label>
									</div>
									<span class='invalid-feedback'
										:class=" hasError('document') ? 'is-invalid' : ''">
										{{ errorMessage('document') }}
									</span>
								</div>
							</div>
							<div class='col-12 row pr-0 mr-0 ml-0 pl-0'>
								<div class='form-group col-6 pl-0'>
									<label class='form-label'>
										Journal
										<span class='required'>*</span>
									</label>
									<input type="text" class="form-control" 
										:class=" hasError('journal') ? 'is-invalid' : ''"
										placeholder="Enter journal name..."
										v-model="journal">
									<span class='invalid-feedback'
										:class=" hasError('journal') ? 'is-invalid' : ''">
										{{ errorMessage('journal') }}
									</span>
								</div>
								<div class='form-group lit-year col-6 pr-0'
									:class=" hasError('year') ? 'is-invalid' : ''">
									<label class='form-label'>
									Published year
									<span class='required'>*</span>
									</label>
									<date-picker 
										v-model="year"
										:type="'year'"
										:input-class="hasError('year') ? 'mx-input is-invalid' : ''"
										:input-style="`width: 100% !important`"
										value-type="format"
										format="YYYY">
									</date-picker>
									<span class='invalid-feedback'
										:class=" hasError('year') ? 'is-invalid' : ''">
										{{ errorMessage('year') }}
									</span>
								</div>
							</div>
							<div class='col-12 row pr-0 mr-0 ml-0 pl-0'>
								<div class='form-group col-6 pl-0 '>
									<label class='form-label'>
										Issue no
									</label>
									<input type="text" class="form-control" 
										placeholder="Enter issue number..."
										v-model="issueNo">
								</div>
								<div class='form-group lit-year col-6 pr-0'>
									<label class='form-label'>
									Volume
									</label>
									<input type="text" class="form-control" 
										placeholder="Enter volume..."
										v-model="volume">
								</div>
							</div>
							<div class='col-12 pl-0 pr-0 form-group tags'>
								<label class='form-label'>
									Publication tags
								</label>
								<vue-tags-input
									v-model="tag"
									:tags="tags"
									:allow-edit-tags="true"
									:avoid-adding-duplicates="true"
									:placeholder="'Add publication tags'"
									:add-from-paste="false"
									@tags-changed="(newTag) => (tags = newTag)"/>
							</div>
						</form>
					</div>
				</div>
    </div>
    <div class='buttons pr-5'>
      <a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
        style="float: right; margin-right: 0px !important;margin-bottom: 20px !important;"
        @click="hideWindow()">
        <i class="far fa-times-circle"></i>&nbsp;Close
      </a>
      	<button class="btn btn-sm btn-primary pull-right mt-2 mr-2"
          style="float: right; margin-bottom: 20px !important;"
          @click="save()">
        <i class="fal fa-arrow-up"></i>&nbsp;Upload
      </button>
    </div>
  </modal>
  </div>
</template>
<script type="text/javascrt">
	import DatePicker from 'vue2-datepicker'
	import Loading from 'vue-loading-overlay'
	import VueTagsInput from '@johmun/vue-tags-input'
	export default {
		data() {
			return {
				editor: false, 
				editorName: '',
				preload: false, 
				documentName: '',
				errors: {},
				author: '',
				title: '',
				abstract: '',
				authors: [],
				document: '',
				journal: '',
				form: new FormData(),
				year: moment().format("YYYY"),
				loading: false,
				databaseId: null,
				issueNo: '',
				volume: '',
				tags: [],
				tag: ''
			}
		},
		computed: {
			searchEndpoint() {
				return $("div#user-data").data().literatureEndpoint
			},
 			submitUrl() {
				if (this.preload) {
					return `${this.searchEndpoint}/publications/${this.databaseId}`
				} else {
					return `${this.searchEndpoint}/publications`
				}
			},
			formData() {
				this.form.append("publication[abstract]", this.abstract)
				this.form.append("publication[publication_title]", this.title)
				this.form.append("publication[year]", this.year)
				this.form.append("publication[issue_no]", this.issueNo)
				this.form.append("publication[journal]", this.journal)
				this.form.append("publication[volume]", this.volume)
				this.form.append("publication[tag_list]", this.tags.map(t => t.text).join(", "))
				this.form.append("publication[document]", this.document)
				return this.form
			},
			fileLabel() {
				if (this.documentName) {
					return this.documentName
				} else {
					return 'Choose file'
				}
			}
		},
		methods: {
			currentEditor(vm, index) {
				return vm.$parent.$refs[`editor-${vm.$parent.section.id}`][0]
				.$refs[`editor-${vm.$parent.section.id}-${index}`]
			},
			putSearch(search) {
				this.$nextTick(() => {
					this.$parent.$refs.input.query = search
				})
			},
			errorMessage(field) {
				if (this.errors[field]) {
					return this.errors[field].join(", ")
				} else {
					return ''
				}
			},
			hasError(field) {
				if (this.errors[field] && this.errors[field].length > 0) {
					return true
				} else {
					return false
				}
			},
			deleteAuthor(data) {
				const author = data.tag.text
				this.form.delete(`publication[authors][${data.index}][first_name]`)
				this.form.delete(`publication[authors][${data.index}][last_name]`)
				this.form.delete(`publication[authors][${data.index}][middle_name]`)
				this.authors.splice(data.index, 1)
				data.deleteTag()
			},	
			addAuthor(data, add = true) {
				const lastAuthor = data.tag.text
				this.authors.push(lastAuthor)
				const idx = this.authors.indexOf(lastAuthor)
				if (/\s/.test(lastAuthor)) {
					if (lastAuthor.split(" ").length  === 3) {
						const firstName = lastAuthor.split(" ")[0]
						const middleName = lastAuthor.split(" ")[1]
						const lastName = lastAuthor.split(" ")[2]
						this.form.append(`publication[authors][${idx}][first_name]`, firstName)
						this.form.append(`publication[authors][${idx}][middle_name]`, middleName)
						this.form.append(`publication[authors][${idx}][last_name]`, lastName)
					} else {
						const firstName = lastAuthor.split(" ")[0]
						const lastName = lastAuthor.split(" ")[1]
						this.form.append(`publication[authors][${idx}][first_name]`, firstName)
						this.form.append(`publication[authors][${idx}][last_name]`, lastName)
					}
				}
				this.author = ''
				if (add && typeof data.addTag === 'function') data.addTag()
			},
			onChangeFile(ev) {
				const file = ev.target.files[0]
				this.documentName = file.name
				this.document = file
			},
			setParams(event) {
				this.editor = event.params.fromEditor
				this.editorName = event.params.name
			},
			resetForm() {
				if (!this.preload) {
					this.documentName = ''
					this.author = ''
					this.title = ''
					this.abstract = ''
					this.databaseId = null,
					this.authors = []
					this.document =  ''
					this.journal = ''
					this.form = new FormData()
					this.year = moment().format("YYYY")
					this.loading = false
					this.issueNo = ''
					this.volume = ''
					this.tags = []
					this.tag = ''
					this.errors = {}	
				}
			},
			hideWindow() {
				this.$modal.hide(`literature-modal`)
			},
			save() {
				this.loading = true
				let vm = this
				return $.ajax({
					method: this.preload ? 'PATCH' : 'POST',
					url: this.submitUrl,
					data: this.formData,
					contentType: false,
					processData: false
				}).done((res) => {
					this.hideWindow()
					this.loading = false
					const name = res.authors[0].last_name
					if (this.editor === false) {
						this.putSearch(name)
					}	
					this.$store.commit('setLastInsertedLiteratureItem', res.reference)
					this.$store.commit('updateEditorId', this.editorName)
				}).catch(e => {
					const jsonData = JSON.parse(e.responseText)
					this.$set(this, 'errors', jsonData.errors)
				}).always(e => {
					this.loading = false
				})
			}
		},
		components: {
			Loading, DatePicker, VueTagsInput
		}
	}
</script>
<style>
.lit-year .mx-datepicker {
	width: 100% !important
}
.authors .ti-input, .tags .ti-input {
	border-color: #e4e9f0
}
.vue-tags-input.is-invalid .ti-input,
.is-invalid.mx-input {
	border-color: #dc3545;
}
</style>
