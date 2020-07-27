<template>
  <modal 
    name="new-shared-folder"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="40%" 
    height="75%">
    <Form />
  </modal>
</template>
<script>
import Form from './Form.vue'
export default {
  components: { Form },
  methods: {
    afterOpened() {
    }
  }
}
</script>