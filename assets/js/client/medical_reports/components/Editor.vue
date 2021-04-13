<template>
	<quill-editor
    :ref="name"
    v-model="content"
		:container="name"
    style='padding: 0px'
		@ready="onEditorReady(this)"
		@change="onEditorChange"
    :options="editorOption"
  />
</template>
<script>
// @ts-nocheck 
import QuillImageDropAndPaste from 'quill-image-drop-and-paste'
Quill.register('modules/imageDropAndPaste', QuillImageDropAndPaste)
const Parchment = Quill.import("parchment")

import { quillEditor } from 'vue-quill-editor'
import { mapState } from 'vuex'
export default {
	props: ['name', 'defaultContent', 'tagId', 'index', 'letter'],
  created() {
    if (this.defaultContent) {
      this.content = this.defaultContent
    }
		this.insertReference()
  },
	watch: {
		lastInsertedLibraryItem: function(newVal, oldVal) {
			if (this.name === this.lastUpdatedEditorId) {
				this.appendEditorText(newVal.short)
			}
		}
	},
  data () {
    return {
      content: '',
      editorOption: {
				height: 100,
				modules: {
					toolbar: [
						['bold', 'italic', 'underline', 'strike'],    
            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
						['image', 'clean'], ['books-medical', 'newspaper']                                            
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
  methods: {
		insertReference() {
			const vm = this
			this.$root.$on('insertReference', (refr) => {
				if (this.letter === 'L') {// insert only in literature sectoin
					const referenceLine = `<p><br/>${refr.authors}<br/>${refr.title}<br/>${refr.rest}</p>`
					this.appendEditorText(referenceLine)
				}
			})
		},
		currentEditor(vm) {
			return vm.$parent.$refs[`editor-${vm.$parent.section.id}`][0].$refs[vm.name].quill
		},
		onEditorReady() {
			if (this.letter && this.letter !== 'L') {
				this.addButton(this, 'books-medical', (vm) => {
					vm.$modal.show('literature-modal', {
						fromEditor: true,
						name: vm.name
					})
				})
				this.addButton(this, 'newspaper', (vm) => {
					vm.$modal.show('reference-modal', {
						fromEditor: true, 
						name: vm.name
					})
				})
			}
		},
		appendEditorText(text) {
			const ed = this.currentEditor(this)
			const selection = ed.getSelection(true)
			if (selection == null) {
				ed.clipboard.dangerouslyPasteHTML(0, text);
			} else {
				ed.clipboard.dangerouslyPasteHTML(selection.index, text);
			}
		},
		addButton(vm, name, callbackFn) {
			let Btn = new Parchment.Attributor.Class(name, `ql-${name}`, {
				scope: Parchment.Scope.INLINE
			})

			Quill.register(Btn, true)
			Array.from(document.querySelectorAll(`.ql-${name}`)).forEach((btn) => {
				btn.addEventListener('click', function() {
				if (callbackFn && typeof callbackFn === 'function') {
					callbackFn(vm)
				}
			})
			$(`button.ql-${name}`)
					.html(`<i class='fal fa-${name}' style='font-size: 18px'></i>`)

			})
		},
    onEditorChange({ quill, html, text }) {
      this.content = html
		},
		body() {
			return this.content
		},
  },
  computed: {
		...mapState(['lastInsertedLibraryItem', 'lastUpdatedEditorId']),
    editor() {
      return this.$refs.comment.quill
    }
  },
	components: {
    quillEditor
  }
}
</script>