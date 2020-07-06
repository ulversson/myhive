<template>
  <div id="bymonth-select" class="btn-toolbar years-choice p-3">
    <div class='row' style='width: 100% !important'>
      <label class='p-3'>Which month(s) of the year does this repeat on</label>
      <div class='col-12'>
        <p>
        <input
          type="radio"
          name="yearly-options"
          v-model="yearlyOptions"
          id="yearly-one-month"
          @change="setYearlyOption('oneMonth')"
          :checked="yearlyOptions === 'oneMonth'"/>
        One Month Out of the Year
      </p>
      </div>
      <div class='col-12'>
        <span style='float: left'>on&nbsp;</span>
        <select name="yearly-bymonth" id="yearly-bymonth" 
          style="width: 120px !important; float:left"
          :disabled="yearlyOptions !== 'oneMonth'"
          @change="emitByMonth"
          v-model="byMonth" class="form-control yearly-one-month">
          <option value="1" selected="yes">January</option>
          <option value="2">February</option>
          <option value="3">March</option>
          <option value="4">April</option>
          <option value="5">May</option>
          <option value="6">June</option>
          <option value="7">July</option>
          <option value="8">August</option>
          <option value="9">September</option>
          <option value="10">October</option>
          <option value="11">November</option>
          <option value="12">December</option>
        </select>
        <select
          name="yearly-bymonthday"
          id="yearly-bymonthday"
          style="width: 65px !important; float: left"
          :disabled="yearlyOptions !== 'oneMonth'"
          v-model="byMonthDay"
          @change="emitByMonthDay"
          class="yearly-one-month form-control">
          <option value="1" selected="yes">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="13">13</option>
          <option value="14">14</option>
          <option value="15">15</option>
          <option value="16">16</option>
          <option value="17">17</option>
          <option value="18">18</option>
          <option value="19">19</option>
          <option value="20">20</option>
          <option value="21">21</option>
          <option value="22">22</option>
          <option value="23">23</option>
          <option value="24">24</option>
          <option value="25">25</option>
          <option value="26">26</option>
          <option value="27">27</option>
          <option value="28">28</option>
          <option value="29">29</option>
          <option value="30">30</option>
          <option value="31">31</option>
        </select>
      </div>
    </div>
    <div class='row mt-3' style='width: 100% !important'>
      <div class='col-12'>
        <p>
          <input type="radio" name="yearly-options" 
           @change="setYearlyOption('multipleMonths')"
           :checked="yearlyOptions === 'multipleMonths'"
          id="yearly-multiple-months" />
          Multiple Months
        </p>
        <MonthRow :collection="firstHalf" 
          :yearlyOptions.sync="yearlyOptions" />
        <MonthRow :collection="secondHalf" 
          :yearlyOptions.sync="yearlyOptions" />
      </div>
    </div>
    <div class='row mt-3' style='width: 100% !important'>
      <div class='col-12'>
        <p>
      <input type="radio" 
        name="yearly-options" 
        @change="setYearlyOption('precise')"
        :checked="yearlyOptions === 'precise'"
        id="yearly-precise" /> Or be
      precise
    </p>
    <span class='pull-left' style='float: left'>
      &nbsp;on the&nbsp;
    </span>
    <select name="yearly-bysetpos" 
      style="width: 100px !important; float:left"
      class="form-control yearly-precise" 
      v-model="bySetPos"
      @change="emitBySetPos"
      :disabled="yearlyOptions !== 'precise'">
      <option value="1" selected="selected">First</option>
      <option value="2">Second</option>
      <option value="3">Third</option>
      <option value="4">Fourth</option>
      <option value="-1">Last</option>
    </select>
    &nbsp;
    <select name="yearly-byday" class="form-control 
      yearly-precise" 
      :disabled="yearlyOptions !== 'precise'"
      v-model="byDay"
      @change="emitByDay"
      style="width: 120px !important; float:left">
      <option value="SU" selected="selected">Sunday</option>
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
    <span class='pull-left' style='float:left'>&nbsp;in&nbsp;</span>
    <select
      name="yearly-bymonth-with-bysetpos-byday"
      id="yearly-bymonth-with-bysetpos-byday"
      class="yearly-precise form-control"
      style="width: 120px !important; float:left"
      v-model="bySpecificMonth"
      @change="emitBySpecificMonth"
      :disabled="yearlyOptions !== 'precise'">
      <option value="1" selected="selected">January</option>
      <option value="2">February</option>
      <option value="3">March</option>
      <option value="4">April</option>
      <option value="5">May</option>
      <option value="6">June</option>
      <option value="7">July</option>
      <option value="8">August</option>
      <option value="9">September</option>
      <option value="10">October</option>
      <option value="11">November</option>
      <option value="12">December</option>
    </select>
    </div>
    </div>
  </div>
</template>
<script>
import MonthRow from './MonthRow.vue'
export default {
  components: { MonthRow },
  created() {
    this.$root.$on('month', (month) => {
      let idx = this.selectedMonths.indexOf(month)
      if (idx === -1) {
        this.selectedMonths.push(month)
      } else {
        this.selectedMonths.splice(idx, 1)
      }
      this.$root.$emit('toggleMonths', this.selectedMonths)
    })
  },
  computed: {
    months() {
      return Array.from(Array(12), (_, i) => i + 1)
    },
    firstHalf() {
      return Array.from(Array(12), (_, i) => i + 1).splice(0, 6)
    },
    secondHalf() {
      return Array.from(Array(12), (_, i) => i + 1).splice(6, 12)
    }
  },
  data() {
    return {
      yearlyOptions: 'oneMonth',
      selectedMonths: [],
      byMonthDay: "",
      byMonth: "",
      bySpecificMonth: "",
      byDay: "",
      bySetPos: ""
    }
  },
  methods: {
    setYearlyOption(option) {
      this.yearlyOptions = option
    },
    emitByMonth() {
      this.$root.$emit('byMonth', this.byMonth)
    },
    emitByMonthDay() {
      this.$root.$emit('byMonthDay', this.byMonthDay)
    },
    emitByDay() {
      this.$root.$emit('changeByDay', this.byDay)
    },
    emitBySetPos() {
      this.$root.$emit('changeBySetPos', this.bySetPos)
    },
    emitBySpecificMonth() {
      this.$root.$emit('byMonth', this.bySpecificMonth)
    }
  }
}
</script>