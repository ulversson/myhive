<template>
  <div class='form-group'
   :class="[
      isFullWidth ? 'col-12' : 'col-6',
      hasError ? 'has-danger' : ''
    ]">
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <input type="number" 
      :name="inputName" 
      class='form-control' 
      v-model="itemValue"
    />
    <span class='help-block' v-if="hasError">
      cannot be blank
    </span>
  </div>
</template>
<script>
import variable from '../mixins/variable'
export default {
  props: ['submit'],
  mixins: [variable]
}
</script>