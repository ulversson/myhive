<template>
  <modal 
    name="new-cal-event"
    :scrollable="true"
    :adaptive="true" 
    width="500" height="530"
    @opened="afterOpened" 
    :reset="true">
    <form class='form-horizontal form-share'>
      <div class='card'>
        <div class='card-header'>
          <span class='cui-utils-title'>Add event</span>
        </div>
        <div class='card-body'>
          <div class='form-group'>
            <label class='form-label'>
              Please enter event name
              <span class='required'>*</span>
            </label>
            <input type='text' class='form-control' v-model="name" />
          </div>
          <div class='form-group'>
            <label class='form-label'>
              Please enter event description
              <span class='required'>*</span>
            </label>
            <textarea v-model="description"
              class='form-control' rows="2" style="max-height: 90px; width: 100%">
            </textarea>
            <span class='text-muted help-block'>More detailed information about the event</span>
          </div>
          <div class='row col-12' style='padding: 0'>
            <div class='form-group col-6' style='margin-left: 0' >
              <label class='form-label'>
                Start Date
                <span class='required'>*</span>
              </label>
              <input placeholder="Start Date" class='form-control mr-1' 
                v-model="startDate">
            </div>
            <div class='form-group col-6' style='margin-left: 0' >
              <label class='form-label'>
                End Date
                <span class='required'>*</span>
              </label>
              <input placeholder="End Date" class='form-control  mr-1' 
                v-model="endDate">
            </div>
            <div class='form-group col-12'>
              <label class='form-label'>
                All day event?
                <span class='required'>*</span>
              </label>
              <div class="ml-2">
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>No
                  <input type="radio" name="radio" :checked="allDay === false">
                  <span class="cui-utils-control-indicator"></span>
                </label>
                <label class="cui-utils-control cui-utils-control-radio"
                  style='width: 70px; float: left'>Yes
                  <input type="radio" name="radio" :checked="allDay === true">
                  <span class="cui-utils-control-indicator"></span>
                </label>
              </div>
            </div>
            <div class='form-group col-12'>
              <label>Recurrence?</label>
              <textarea name='recurrence' id='recurrence' 
                v-model="recurrence" class='recurrence'>
              </textarea>
            </div>
          </div>
          <div class='buttons' style='float: right'>
            <a class='btn btn-sm btn-primary pull-right mt-2'
              @click="addEvent()"
              :style="submitDisabled ?'cursor: not-allowed': ''"
              :disabled="submitDisabled">
              <i class="fas fa-calendar-plus"></i>&nbsp;Add event
            </a>
            <a class='btn btn-sm btn-secondary pull-right mt-2'
              @click="hideModal()">
              <i class="far fa-times-circle"></i>&nbsp;Close
            </a>
          </div>
        </div>
      </div>
    </form>
  </modal>
</template>
<script>
import autosize from 'autosize'

export default {
  data() {
    return {
      recurrence: '',
      description: '',
      startDate: '',
      endDate: '',
      name: '',
      allDay: false
    }
  },
  methods: {
    addEvent() {

    },
    hideModal() {
      this.$modal.hide('new-cal-event')
    },
    afterOpened() {
      autosize(document.querySelectorAll('textarea'))
      $("textarea.recurrence").recurrenceinput({
        startField: "readonly_start",  
        ajaxURL: document.URL, 
        readOnly: false
      })
      $.tools.recurrenceinput.localize("en", {
        longDateFormat: 'dddd dd mmmm, yyyy',
        shortDateFormat: 'mm/dd/yyyy'
      })
      $('div.rimain button[name="riedit"]')
        .addClass('btn btn-sm btn-warning')
      $('div.rimain button[name="ridelete"]')
        .addClass('btn btn-sm btn-danger')
      $('input.risavebutton')
        .addClass('btn btn-sm btn-info')
    }
  }
}
</script>
<style>
div.riform {
  z-index: 10000;
}
div#calroot {
}
div.riform input, div.riform select {
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
</style>