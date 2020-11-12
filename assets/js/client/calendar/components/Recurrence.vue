<template>
  <modal 
    name="recurrence"
    :scrollable="true"
    :adaptive="true" 
    width="500"
    height="auto"
    @opened="afterOpened" 
    :reset="false">
    <div class='rec-form row p-3'>
      <div class='col-12'>
        <p>Frequency
          <select name="freq" class='form-control' v-model="freq">
            <option value="daily" class="days">Daily</option>
            <option value="weekly" class="weeks">Weekly</option>
            <option value="monthly" class="months">Monthly</option>
            <option value="yearly" class="years">Yearly</option>
          </select>
        </p>
      </div>
      <div class='daily col-12'>
        <p>Every 
          <input type="text" class='form-control' 
            style="width: 50px; display: inline-block"
            v-model="interval"
            name="interval" value="1" size="2" /> 
            <span class="freq-selection">
              {{repeatLabel}}
            </span>
        </p>
      </div>
      <ByWeekDay v-if="freq === 'weekly'" 
        :days.sync="days" />
      <ByMonth v-if="freq === 'yearly'" 
        :bySetPos.sync="bySetPos"
        :byDay.sync="byDay"
        :daysOfMonthArray.sync="daysOfMonthArray"/>
      <ByMonthDay v-if="freq === 'monthly'" />
      <div id="until-rules" class='p-3'>
        <p>Until</p>
        <p>
          <label for="count-select">
            <input type="radio" name="end-select" value="count" id="count-select" 
              @change="setEndSelect('count')"
              :checked="endDate === 'count'"/> 
              How many times does this event occur? 
            <input autocomplete="off" 
              class='form-control' style='width:60px'
              type="number" name="count" min="1" 
              v-model="count"
              :disabled="endDate !== 'count'"
              max="50" value="1" step="1"/> 
          </label>
        </p>
        <p>
          <label for="until-select">
            <input type="radio" 
             @change="setEndSelect('until')"
             :checked="endDate === 'until'"
              v-model="endDate"
              name="end-select" value="until" id="until-select" /> 
              Specific Date (aka until) 
            <datetime type="datetime" 
              :disabled="endDate !== 'until'"
              v-model="untilDate"
              input-class='form-control' />
          </label>
        </p>
      </div>
    </div>
     <div class='buttons mb-3 mr-3' style='float: right'>
      <a class='btn btn-sm btn-myhive active pull-right mt-2'
        @click="setRRule()">
        <i class="fas fa-calendar-plus"></i>&nbsp;Save
      </a>
      <a class='btn btn-sm btn-secondary pull-right mt-2'
        @click="hideModal()">
        <i class="far fa-times-circle"></i>&nbsp;Close
      </a>
    </div>
  </modal>
</template>
<script>
import { Datetime } from 'vue-datetime'
import ByWeekDay from './recurrence/ByWeekDay.vue'
import ByMonth from './recurrence/ByMonth.vue'
import ByMonthDay from './recurrence/ByMonthDay.vue'
import recurrence from '../mixins/recurrence'

export default {
  mixins: [recurrence],
  props: ['startDate'],
  components: { ByWeekDay, ByMonth, ByMonthDay, Datetime },
  methods: {
    afterOpened() {},
    setEndSelect(value) {
      this.endDate = value
    },
    hideModal() {
      this.$modal.hide('recurrence')
      this.$parent.$parent.setRecurrence(false)
    },
    setRRule() {
      let rule = this.rruleGenerate()
      this.$parent.$parent.recurrenceRuleString = rule
      this.$modal.hide('recurrence')
    }
  },
  watch: {
    freq: function(newVal, oldVal) {
      if (newVal === 'daily') {
        this.byMonth = ''
        this.byMonthDay = ''
      }
    }
  },
  data() {
    return {
      freq: 'daily',
      endDate: 'count',
      days: [],
      bySetPos: "",
      byDay: "",
      byMonth: "",
      byMonthDay: "",
      daysOfMonthArray: [],
      selectedMonths: [],
      interval: '1',
      untilDate: '',
      count: 1
    }
  },
  created() {
    this.$root.$on('changeBySetPos', (val) => {
      this.bySetPos = val
    })
    this.$root.$on('changeByDay', (val) => {
      this.byDay = val
    })
    this.$root.$on('toggleDay', (daysOfMonthArray) => {
      this.daysOfMonthArray.splice(0, this.daysOfMonthArray.length)
      daysOfMonthArray.forEach((i) => this.daysOfMonthArray.push(i))
    })
    this.$root.$on('byMonth', (val) => {
      this.byMonth = val
    })
    this.$root.$on('byMonthDay', (val) => {
      this.byMonthDay = val
    })
    this.$root.$on('toggleMonths', (months) => {
      this.selectedMonths.splice(0, this.selectedMonths.length)
      months.forEach((i) => this.selectedMonths.push(i))
    })
  },
  computed: {
    startDateFormatted() {
      return moment.utc(this.startDate).format('YYYYMMDDTHHmmss')
    },
    untilDateFormatted() {
      if (this.untilDate !== '') {
        return moment.utc(this.untilDate).format('YYYYMMDDTHHmmss')
      } else {
        return ''
      }
    },
    recurringRule() {
      let data =  {
        freq: this.freq,
        interval: this.interval,
        byday: "",
        bysetpos: "",
        bymonthday: "",
        bymonth: "",
      }
      if (this.endDate === 'count') {
        data.count = this.count
        this.$set(data, 'count', this.count)
        this.$set(data, 'until', '')
      }
      if (this.endDate === 'until') {
        this.$set(data, 'until', this.untilDateFormatted)
        this.$set(data, 'count', '')
      }
      if (this.days.length > 0) {
        this.$set(data, 'byday', this.days.join(','))
        this.$set(data, 'bymonthday','')
        this.$set(data, 'bymonth','')
      }
      if (this.daysOfMonthArray.length > 0) {
        this.$set(data, 'bymonthday', this.daysOfMonthArray.join(','))
        this.$set(data, 'byday','')
        this.$set(data, 'bymonth','')
        this.$set(data, 'bysetpos','')
      }
      if (this.byDay !== "" && this.bySetPos !== "" && this.byMonth === '') {
        this.$set(data, 'byday', this.byDay)
        this.$set(data, 'bysetpos', this.bySetPos)
        this.$set(data, 'bymonthday','')
        this.$set(data, 'bymonth','')
      }
       if (this.byDay !== "" && this.bySetPos !== "" && this.byMonth !== '') {
        this.$set(data, 'byday', this.byDay)
        this.$set(data, 'bysetpos', this.bySetPos)
        this.$set(data, 'bymonth',this.byMonth)
        this.$set(data, 'bymonthday','')
      }
      if (this.byMonth !== "" && this.byMonthDay !== "") {
        this.$set(data, 'bymonth', this.byMonth) 
        this.$set(data, 'bymonthday', this.byMonthDay)
        this.$set(data, 'byday','')
        this.$set(data, 'bysetpos','')
      }
      if (this.selectedMonths.length > 0) {
        this.$set(data, 'bymonth', this.selectedMonths.join(',')) 
        this.$set(data, 'bymonthday','')
        this.$set(data, 'byday','')
        this.$set(data, 'bysetpos','')
      }
      return data
    },
    repeatLabel() {
      switch(this.freq) {
        case 'daily':
          return 'day/s'
        case 'weekly':
          return 'weeks'
        case 'monthly':
          return 'months'
        case 'yearly':
          return 'years'
      }
    }
  }
}
</script>