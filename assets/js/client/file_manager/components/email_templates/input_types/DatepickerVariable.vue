<template>
  <datetime
    type="date"
    :style="'width: 100%'"
    @close="submit = false"
    :class="'col-6'"
    :input-class="'col-12'"
    v-model="selectedDate">
    <p for="startDate" slot="before" style="margin-bottom: 0.5rem !important">
      {{ variable.name }}
      <span class='required'>*</span>
    </p>
    <br/>
    <template slot="button-cancel">
      <i class="fas fa-ban"></i>
      Cancel
    </template>
    <template slot="button-confirm">
      <i class="fas fa-check"></i>
      Confirm
    </template>
  </datetime>
</template>
<script>
import { Datetime } from "vue-datetime";
export default {
  components: { Datetime },
  computed: {
    variable() {
      return this.$parent.$attrs.variable
    }
  },
  data() {
    return {
      selectedDate: null
    }
  }
}
</script>
