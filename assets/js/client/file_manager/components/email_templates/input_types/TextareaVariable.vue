<template>
    <div class='form-group'
    :class="isFullWidth ? 'col-12' : 'col-6'">
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
import variable from '../mixins/variable'

export default {
  mixins: [variable]
}
</script>