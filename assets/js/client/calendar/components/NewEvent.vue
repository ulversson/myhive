<template>
  <modal 
    name="new-cal-event"
    :scrollable="true"
    :adaptive="true" 
    height="auto"
    @opened="afterOpened" 
    :reset="false">
    <form class='form-horizontal form-share'>
      <div class='card'>
        <div class='card-header'>
          <span class='cui-utils-title'>{{ header }}</span>
        </div>
        <div class='card-body'>
          <div class='form-group'
            :class="nameError !== null ? 'is-invalid' : ''">
            <label class='form-label'>
              Please enter event name
              <span class='required'>*</span>
            </label>
            <input type='text' 
              @change="nameError = null"
              :class="nameError !== null ? 'is-invalid' : ''"
              class='form-control' v-model="name" />
          </div>
          <span class='invalid-feedback name-error' 
            v-if="nameError !== null">
            {{nameError}}
          </span>
          <div class='form-group'>
            <label class='form-label'>
              Please enter event description
              <span class='required'>*</span>
            </label>
            <textarea v-model="description"
              @change="descriptionError = null"
              :class="descriptionError !== null ? 'is-invalid' : ''"
              class='form-control' rows="2" style="max-height: 90px; width: 100%">
            </textarea>
            <span class='invalid-feedback description-error' 
              v-if="descriptionError !== null">
              {{descriptionError}}
            </span>
            <span class='text-muted help-block'>
              More detailed information about the event
            </span>
          </div>
          <div class='row col-12' style='padding: 0'>
            <div class='form-group col-6' style='margin-left: 0' >
              <label class='form-label'>
                Start Date
                <span class='required'>*</span>
              </label>
              <datetime type="datetime"
                @close="startTimeError = null"
                :input-class="startTimeError !== null ? 'is-invalid' : ''"
                :class="startTimeError !== null ? 'is-invalid' : ''"
                v-model="startDate"></datetime>
                <span class='invalid-feedback start-time-error' 
                  v-if="startTimeError !== null">
                  {{startTimeError}}
                </span>
            </div>
            <div class='form-group col-6' style='margin-left: 0' >
              <label class='form-label'>
                End Date
                <span class='required'>*</span>
              </label>
              <datetime type="datetime"
                @close="endTimeError = null"
                :input-class="endTimeError !== null ? 'is-invalid' : ''"
                :class="endTimeError !== null ? 'is-invalid' : ''"
                v-model="endDate"></datetime>  
                <span class='invalid-feedback end-time-error' 
                  v-if="endTimeError !== null">
                  {{endTimeError}}
                </span>          
            </div>
            <div class='form-group col-12'>
              <label class='form-label'>
                All day event?
                <span class='required'>*</span>
              </label>
              <div class="ml-2">
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>No
                  <input type="radio" name="radio" :checked="allDay === false"
                    class='all-day' value='false'>
                  <span class="cui-utils-control-indicator"></span>
                </label>
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>Yes
                  <input type="radio" name="radio" :checked="allDay === true"
                    class='all-day' value='true'>
                  <span class="cui-utils-control-indicator"></span>
                </label>
              </div>
            </div>
            <div class='form-group col-12'>
              <label>Recurrence?</label>
              <input type="hidden" :value="recurrence" />
              <div class="ml-2">
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>No
                  <input type="radio" name="radio-rec" :checked="recurrence === false"
                    @change="setRecurrence(false)"
                    class='recurrence' value='false'>
                  <span class="cui-utils-control-indicator"></span>
                </label>
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>Yes
                  <input type="radio" name="radio-rec" :checked="recurrence === true"
                    @change="setRecurrence(true)"
                    class='recurrence' value='true'>
                  <span class="cui-utils-control-indicator"></span>
                </label>
                <span class='text-muted' v-if="recurrenceRuleText !== ''">
                  {{ recurrenceRuleText }}
                </span>
              </div>
            </div>
          </div>
          <div class='buttons' style='float: right'>
            <a class='btn btn-sm btn-primary pull-right mt-2'
              @click="formAction()"
              :style="submitDisabled ?'cursor: not-allowed': ''"
              :disabled="submitDisabled">
              <i class="fas fa-calendar-plus"></i>&nbsp;SAVE
            </a>
            <a class='btn btn-sm btn-secondary pull-right mt-2'
              @click="hideModal()">
              <i class="far fa-times-circle"></i>&nbsp;Close
            </a>
          </div>
        </div>
      </div>
      <Recurrence 
        :startDate="startDate" ref="rec"/>
    </form>
  </modal>
</template>
<script>
import { Datetime } from 'vue-datetime'
import calEvent from '../mixins/calendarEvent'
import Recurrence from './Recurrence.vue'
import { RRule, RRuleSet, rrulestr } from 'rrule'

export default {
  mixins: [calEvent],
  data() {
    return {
      recurrence: false,
      startTimeError: null,
      endTimeError: null,
      descriptionError: null,
      recurrenceRuleString: '',
      nameError: null,
      currentEvent: null,
      description: '',
      startDate: '',
      endDate: '',
      name: '',
      edit: false,
      allDay: false
    }
  },
  watch: {
    recurrence: function(newVal, oldVal) {
      if (newVal) {
        this.$modal.show('recurrence')
      } else {
        this.$modal.hide('recurrence')
        this.recurrenceRuleString = ''
      }
    }
  },
  computed: {
    header() {
      if (this.edit) {
        return "Edit event"
      } else {
        return "Add event"
      }
    },
    recurrenceRuleText() {
      if (this.recurrenceRuleString === '') return
      return RRule.fromString(this.recurrenceRuleString).toText()
    },
    submitDisabled() {
      return this.nameError !== null && this.startTimeError !== null
        && this.endTimeError !== null && this.descriptionError !== null
    },
    calendar() {
      return this.$parent.$refs.cal.getApi()
    },
    calEventData() {
      return {
        event_params: {
          name: this.name,
          description: this.description,
          start_date: this.startDate,
          end_date: this.endDate,
          all_day: $("input.all-day:checked").val(),
          recurrence: this.recurrenceRuleString
        }
      }
    }
  },
  methods: {
    formAction() {
      if (this.edit) {
        this.updateEvent() 
      } else {
        this.addEvent()
      }
    },
    setRecurrence(value) {
      this.recurrence = value
    },
    renderErrors(err) {
      let jsonError = JSON.parse(err.responseText)
      if (jsonError.errors.hasOwnProperty('description')) {
        this.descriptionError = jsonError.errors.description.join(', ')
      }
      if (jsonError.errors.hasOwnProperty('start_date')) {
        this.startTimeError  = jsonError.errors.start_date.join(', ')
      }
      if (jsonError.errors.hasOwnProperty('end_date')) {
        this.endTimeError  = jsonError.errors.end_date.join(', ')
      }
      if (jsonError.errors.hasOwnProperty('name')) {
        this.nameError  = jsonError.errors.name.join(', ')
      }
    },
    addEvent() {
      let vm = this
      $.post(`/api/v1/calendar_events`, this.calEventData, (res) => {
        //this.calendar.addEvent(this.dbEventToFullcalendar(res))
        //this.hideModal()
       window.location.reload(true)
      }).catch((err) => {
        this.renderErrors(err)
      })
    },
    updateEvent() {
      $.ajax({
        type: "PUT",
        data: this.calEventData,
        url: `/api/v1/calendar_events/${this.currentEvent}`
      }).done((res) => {
        window.location.reload(true)
      }).fail((err) => {
        this.renderErrors(err)
      })
    },
    hideModal() {
      this.$modal.hide('new-cal-event')
    },
    afterOpened() {
      this.setupUI()
      this.$emit('setupUI')
      if (!this.edit && this.startDate === '' && this.endDate ==='') this.reset()
    },
    reset() {
      this.startDate = ''
      this.endDate = ''
      this.name = ''
      this.allDay = false
      this.description = ''
      this.edit = false
      this.currentEvent = null
      this.startTimeError = null
      this.endTimeError = null
      this.descriptionError = null
      this.recurrenceRuleString = ''
      this.nameError = null
    }
  },
  components: { Datetime, Recurrence }
}
</script>
<style>
input.vdatetime-input {
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  color: #495057;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #ced4da;
  border-radius: 0.25rem;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
input.vdatetime-input {
  height: calc(1.5em + 0.75rem + 2px);
  padding: 0.375rem 0.75rem;
}
input.vdatetime-input.is-invalid {
  border: 1px solid #dc3545 !important;
}
</style>