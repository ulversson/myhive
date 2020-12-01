<template>
  <datetime
    type="date"
    :style="'width: 100%'"
    @close="submit = false"
    :name="inputName"
    :class="computedClass"
    :input-class="hasDateError ? 'form-control col-12 has-danger' : 'form-control col-12'"
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
    <template slot="after">
      <span class='help-block' v-if="hasDateError">
        cannot be blank
      </span>
    </template>
  </datetime>
</template>
<script>
import { Datetime } from "vue-datetime"
import variable from '../mixins/variable'

export default {
  components: { Datetime },
  mixins: [variable],
  computed: {
    hasDateError() {
      return !(this.selectedDate) && this.submit
    },
    computedClass() {
      if (this.hasDateError) {
        return this.withErrorClass
      } else {
        return this.withoutErrorClass
      }
    },
    withErrorClass() {
     if (this.isFullWidth) {
        return 'form-group has-danger col-12'
     } else {
        return 'form-group has-danger col-6'
     }
    },
    withoutErrorClass() {
       if (this.isFullWidth) {
        return 'col-12'
      } else {
        return 'col-6'
      }
    }
  },
  data() {
    return {
      selectedDate: null
    }
  }
}
</script>
