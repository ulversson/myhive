<template>
  <modal 
    :name="modalName"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="40%" 
    height="75%">
    <Form formType="edit" :folder="folder" :isAdmin="isAdmin"/>
  </modal>
</template>
<script>
import Form from './Form.vue'
export default {
  props: ['folder', 'isAdmin'],
  components: { Form },
  computed: {
    modalName() {
      return `edit-shared-folder-${this.folder.id}`
    }
  },
  methods: {
    afterOpened() {
    }
  }
}
</script>