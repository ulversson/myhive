<template>
	<quill-editor
    :ref="name"
    v-model="content"
    style= 'padding: 0px'
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
	props: ['name', 'defaultContent'],
  created() {
    if (this.defaultContent) {
      this.content = this.defaultContent
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
						['image', 'clean'],                                            
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
      console.log(html)
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

</style>
