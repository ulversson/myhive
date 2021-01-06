<template>
	<quill-editor
    ref="comment"
    v-model="content"
		@change="onEditorChange"
    :options="editorOption"
  />
</template>
<script>
// @ts-nocheck
import { quillEditor } from 'vue-quill-editor'
export default {
	props: ['status'],
  data () {
    return {
      content: '',
      editorOption: {
				height: 400,
				modules: {
					toolbar: [
  					['bold', 'italic', 'underline', 'strike'],        
  					['blockquote'],
						[{ 'indent': '-1'}, { 'indent': '+1' }],          
						[{ 'header': [1, 2, 3, 4, false] }],
						[{ 'color': [] }, { 'background': [] }],        
						[{ 'font': [] }],
						[{ 'align': [] }],
						['clean']                                         
					]
				}
			}
		}
  },
  methods: {
    onEditorChange({ quill, html, text }) {
      this.content = html
		},
  },
  computed: {
		formData() {
			return {
				comment: {
					body: this.content,
					id: this.status.id
				}
			}
		},
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
