<template>
	<quill-editor
    :ref="name"
    v-model="content"
		@change="onEditorChange"
    :options="editorOption"
  />
</template>
<script>
// @ts-nocheck
import QuillImageDropAndPaste from 'quill-image-drop-and-paste'
Quill.register('modules/imageDropAndPaste', QuillImageDropAndPaste)
import { quillEditor } from 'vue-quill-editor'
export default {
	props: ['name'],
  data () {
    return {
      content: '',
      editorOption: {
				height: 300,
				modules: {
					toolbar: [
						['bold', 'italic', 'underline', 'strike'],    
            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
						['image'],                                            
						['clean'],
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
    onEditorChange({ quill, html, text }) {
      this.content = html
		},
		body() {
			return this.content
		}
  },
  computed: {
    editor() {
      return this.$refs.comment.quill
    }
  },
	components: {
    quillEditor
  }
}
</script>
<style>
.ql-editor{
  min-height:200px;
}
</style>
