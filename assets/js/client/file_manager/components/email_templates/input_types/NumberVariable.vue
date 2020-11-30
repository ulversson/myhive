<template>
  <div class='form-group col-6'>
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <input type="number" :name="variable.code" 
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