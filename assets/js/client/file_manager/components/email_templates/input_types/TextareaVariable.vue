<template>
    <div class='form-group col-6'>
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <textarea 
      :name="variable.code" 
      rows="2"
      style='resize: none'
      class='form-control'/>
  </div>
</template>
<script>
export default {
  computed: {
    variable() {
      return this.$parent.$attrs.variable
    }
  }
}
</script>