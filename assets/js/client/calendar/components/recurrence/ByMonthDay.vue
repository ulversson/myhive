<template>
  <div id="monthday-select"
    class="btn-toolbar months-choice p-3"
    role="toolbar">
    <div class='row' style='width: 100%'>
      <div class='col-12 p-3'>
        <input
          type="radio"
          name="monthday-pos-select"
          value="monthday-selected"
          id="monthday-selected"
          @change="setMode('byDay')"
          :checked="monthDayMode === 'byDay'"/>

        <label >Which day(s) of the month does this repeat on</label>
        <WeekRow :collection="firstWeek" 
          :monthDayMode="monthDayMode" />
        <WeekRow :collection="secondWeek" 
          :monthDayMode="monthDayMode" />
        <WeekRow :collection="thirdWeek" 
          :monthDayMode="monthDayMode" />
        <WeekRow :collection="fourthWeek" 
          :monthDayMode="monthDayMode" />
         <WeekRow :collection="fifthWeek" 
          :monthDayMode="monthDayMode" />
      </div>
    </div>

    <!-- BYDAY -->
    <div class='row'>
      <div class='col-12'>
        <input style='float: left' type="radio"
          name="monthday-pos-select"
          @change="setMode('byDayPos')"
          value="month-byday-pos-selected"
          :checked="monthDayMode === 'byDayPos'"
          id="month-byday-pos-selected" />
        <span class='pull-left' style='float: left'>
          &nbsp;Or&nbsp;
        </span>
        <select name="month-byday-pos" 
          class='form-control'
          style='width: 100px !important; float: left'
          v-model="bySetPos"
          @change="emitChangeBySetPos"
          :disabled="monthDayMode !== 'byDayPos'">
          <option value="1" selected="selected">First</option>
          <option value="2">Second</option>
          <option value="3">Third</option>
          <option value="4">Fourth</option>
          <option value="-1">Last</option>
        </select>
        <select name="month-byday-pos-name" 
          class='form-control'
          style='width: 120px !important; float: left'
          v-model="byDay"
          @change="emitChangeByDay"
          :disabled="monthDayMode !== 'byDayPos'">
          <option value="SU">Sunday</option>
          <option value="MO">Monday</option>
          <option value="TU">Tuesday</option>
          <option value="WE">Wednesday</option>
          <option value="TH">Thursday</option>
          <option value="FR">Friday</option>
          <option value="SA">Saturday</option>
          <option value="SU,MO,TU,WE,TH,FR,SA" selected="selected">Day</option>
          <option value="MO,TU,WE,TH,FR">Weekday</option>
          <option value="SU,SA">Weekend day</option>
        </select>
      </div>
    </div>
  </div>
</template>
<script>
import WeekRow from './WeekRow.vue'
export default {
  components: { WeekRow },
  computed: {
    daysOfMonth() {
      return Array.from(Array(31), (_, i) => i + 1)
    },
    firstWeek() {
      return this.daysOfMonth.slice(0,7)
    },
    secondWeek() {
      return this.daysOfMonth.slice(7,14)
    },
    thirdWeek() {
      return this.daysOfMonth.slice(14,21)
    },
    fourthWeek() {
      return this.daysOfMonth.slice(21,28)
    },
    fifthWeek() {
      return this.daysOfMonth.slice(29,31)
    }
  }, 
  data() {
    return {
      daysOfMonthArray: [],
      monthDayMode: "byDay",
      bySetPos: null,
      byDay: null
    }
  },
  created() {
    this.$on('toggleDay', (day) => {
      this.toggleDay(day)
    })
  },
  methods: {
    emitChangeBySetPos() {
      this.$root.$emit('changeBySetPos', this.bySetPos)
    },
    emitChangeByDay() {
      this.$root.$emit('changeByDay', this.byDay)
    },
    setMode(mode) {
      this.monthDayMode = mode
      this.resetMonths()
      this.bySetPos = ""
      this.byDay = ""
      this.emitChangeBySetPos()
      this.emitChangeByDay()
    },
    toggleDay(day) {
      let idx = this.daysOfMonthArray.indexOf(day)
      if (idx === -1) {
        this.daysOfMonthArray.push(day)
      } else {
        this.daysOfMonthArray.splice(idx, 1)
      }
      this.$root.$emit('toggleDay', this.daysOfMonthArray)
    },
    resetMonths() {
      this.daysOfMonthArray.splice(0, this.daysOfMonthArray.length)
      this.$root.$emit('toggleDay', this.daysOfMonthArray)
    }
  }
}
</script>