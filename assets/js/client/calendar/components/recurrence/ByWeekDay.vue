<template>
  <div id="weekday-select" class="p-3 btn-toolbar weeks-choice" 
    role="toolbar">
    <label>
      Which day(s) of the week does this repeat on:
    </label>
    <div class="btn-group" data-toggle="buttons">
      <label class="btn btn-primary" 
        v-for="day in daysOfWeeks" :key="day">
        <input type="checkbox" name='week' @change="toggleDay(day)" >
          {{day}}
      </label>
    </div>
  </div>
</template>
<script>
export default {
  props: ['days'],
  data() {
    return {
      daysOfWeeks: ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU']
    }
  },
  methods: {
    toggleDay(day) {
      this.$parent.$emit('dayOfWeek', day)
      let idx = this.days.indexOf(day)
      if (idx === -1) {
        this.days.push(day)
      } else {
        this.days.splice(idx, 1)
      }
    }
  }
}
</script>