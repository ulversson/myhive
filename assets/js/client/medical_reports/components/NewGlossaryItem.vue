<template>
	<modal
		name="got-modal"
		width="40%"
		height="auto"
		:adaptive="true"
		:scrollable="true"
		@before-open="setParams"
		@opened="resetForm"
		styles="font-size: 13px"
		:reset="true">
		<div class="card">
			<div class="card-header">
      	<h4>Add glossary item</h4>
			</div>
			<div class='card-body'>
				<div class="form-group">
				<label for="input-post-title">
					<strong>Name</strong>
					<span class='reuqired'></span>
				</label>
    		<input type="text" class='form-control' v-model="name" 
					:class=" hasError('name') ? 'is-invalid' : ''"/>
				<span class='invalid-feedback'
					:class=" hasError('name') ? 'is-invalid' : ''">
					{{ errorMessage('name') }}
				</span>
    		<span class='invalid-feedback' id='glossary_of_term_name'></span>
  		</div>
			<div class="form-group">
				<label for="input-post-title">
					<strong>Acronym or short name</strong>
				</label>
					<input type="text" class='form-control' v-model="shortName" />
			</div>
			<div class="form-group"
				:class=" hasError('description') ? 'is-invalid' : ''">
				<div class="cui-add-post-description">
					<label><strong>Description</strong></label>
					<quill-editor
						ref="description"
						v-model="description"
						style='padding: 0px'
						:options="editorOption"/>
					<span class='invalid-feedback'
						:class=" hasError('description') ? 'is-invalid' : ''">
						{{ errorMessage('description') }}
				</span>
				</div>
			</div>
			<div class="form-group mt-5" style="float:right">
				<a class="btn btn-myhive btn-sm" id='save-and-post-got'
					@click="saveItem">
					<i class='fal fa-save'></i>&nbsp;Save item
				</a>
				<a class="btn btn-sm btn-secondary" @click="hideModal()">
					<i class='fal fa-ban'></i>&nbsp;Discard
				</a>
			</div>
		</div>
	</div>
</modal>
</template>
<script>
	import QuillImageDropAndPaste from 'quill-image-drop-and-paste'
	Quill.register('modules/imageDropAndPaste', QuillImageDropAndPaste)
	import { quillEditor } from 'vue-quill-editor'
	export default {
		props: ['items'],
		data() {
			return {
				errors: {},
				name: null,
				shortName: null, 
				description: null,
				editorOption: {
					height: 100,
					modules: {
						toolbar: [
							['bold', 'italic', 'underline', 'strike'],    
							[{ 'list': 'ordered'}, { 'list': 'bullet' }],
							['image', 'clean']                                   
						],
						imageDropAndPaste: {},
						imageResize: {
							displaySize: true
						},
						clipboard: {
							matchVisual: false
						}
					}
				}
			}
		},
		components: {  quillEditor },
		computed: {
			formData() {
				return {
					glossary_item: {
						name: this.name,
						description: this.description,
						short_name: this.shortName
					}
				}
			}
		}, 
		methods: {
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
			setParams() {},
			resetForm() {
				this.name = null
				this.shortName = null
				this.description = null
			},
			setErorrs(errors) {
				this.$set(this, 'errors', errors)
			},
			saveItem() {
				this.setErorrs({})
				$.ajax({
					url: `/api/v1/glossary`,
					type: 'POST',
					data: this.formData,
				}).done((got) =>{
					this.hideModal()
					got.text = got.name
					got.value = got.id
					got.tiClasses = ['ti-valid']
					this.items.push(got)
				}).catch(err => {
					const jsonData = JSON.parse(err.responseText)
					this.setErorrs(jsonData.errors)
				})
			},
			hideModal() {
				this.$modal.hide('got-modal')
			}
		}
	}
</script>
