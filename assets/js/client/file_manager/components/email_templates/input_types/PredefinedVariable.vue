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
    <input type="text" :name="inputName" 
      :class="hasError ? 'has-error' : ''"
      class='form-control' disabled
      v-model="itemValue"/>
    <span class='help-block' v-if="hasError">
      cannot be blank
    </span>
  </div>
</template>
<script>
import variable from '../mixins/variable'
export default {
	created() {
		if (this.predefinedValue) {
			this.itemValue = this.predefinedValue
		}
	},
  props: ['submit', 'predefinedValue'],
  mixins: [variable]
}
</script>