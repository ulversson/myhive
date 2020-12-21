<template>
  <datetime
    type="time"
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
import timedate from '../mixins/timedatecommon'
export default {
 mixins: [timedate]
}
</script>
