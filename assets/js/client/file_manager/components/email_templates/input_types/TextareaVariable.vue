<template>
  <div class='form-group'
    :class="isFullWidth ? 'col-12' : 'col-6'">
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <quill-editor
      :name="variable.code"
      v-model="content"
      ref="editor"
      @change="onEditorChange"
      :options="editorOption"
    />
  </div>
</template>
<script>
import QuillImageDropAndPaste from 'quill-image-drop-and-paste'
Quill.register('modules/imageDropAndPaste', QuillImageDropAndPaste)
import { quillEditor } from 'vue-quill-editor'
import variable from '../mixins/variable'
export default {
  mixins: [variable],
  components: {
    quillEditor
  },
  methods: {
    onEditorChange({ quill, html, text }) {
      this.content = html
      var variable = {}
      variable[this.inputName] = html
      this.$root.$emit('variable', variable)
    },
    body() {
      return this.content
    }
  },
  computed: {
    editor() {
      return this.$refs.editor.quill
    }
  },
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
  }
}
</script>