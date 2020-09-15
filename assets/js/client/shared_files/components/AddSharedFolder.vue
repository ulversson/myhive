<template>
  <modal 
    name="new-shared-folder"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="40%" 
    height="480px">
    <Form formType="new" :isAdmin="isAdmin"/>
  </modal>
</template>
<script>
import Form from './Form.vue'
export default {
  components: { Form },
  props: ['isAdmin'],
  methods: {
    afterOpened() {
    }
  }
}
</script>