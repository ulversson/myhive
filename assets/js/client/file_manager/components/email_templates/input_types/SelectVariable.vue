<template>
  <div class="form-group col-6">
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <v-select label="name" 
    :options="experts"
      v-model="selectedExpert">
      <template v-slot:option="option">
        <i class='fas fa-user'></i>&nbsp;
        {{ option.name }}&nbsp;
      </template>
    </v-select>
  </div>
</template>
<script>
export default {
  data() {
    return {
      selectedExpert: null,
      experts: []
    }
  },
  computed: {
    variable() {
      return this.$parent.$attrs.variable
    }
  }
}
</script>