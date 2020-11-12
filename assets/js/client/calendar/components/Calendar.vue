<template>
  <div class='row'>
    <div class='col-md-12'>
      <NewEvent ref="newEvent" />
      <FullCalendar :options="calendarOptions" ref='cal' />
      <event-info :eventObj="currentEvent"/>
    </div>
  </div>
</template>
<script>
import FullCalendar from '@fullcalendar/vue'
import NewEvent from './NewEvent.vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import bootstrapPlugin from '@fullcalendar/bootstrap'
import interactionPlugin from '@fullcalendar/interaction'
import calEvent from '../mixins/calendarEvent'
import EventInfo from './EventInfo.vue'
export default {
  mixins: [calEvent],
  components: {
    FullCalendar, NewEvent, EventInfo
  },
  created() {
    UI.setup()
    this.loadEvents()
    this.$on('setupUI', this.setupUI)
  },
  watch: {
    currentEvent: function(newVal, oldVal) {
      this.$modal.show('event-info', {
        eventObj: newVal
      })
    }
  },
  data() {
    let vm = this
    return {
      currentEvent: null,
      calendarOptions: {
        draggable: true,
        editable: true,
        selectable: true,
        selectMirror: true,
        firstDay: 1,
        nowIndicator: true, 
        event: null,
        headerToolbar: {
          left  : 'prev,next today addEvent',
          center: 'title',
          right : 'dayGridMonth,timeGridWeek,timeGridDay,listDay,listWeek,listMonth'
        },
        buttonText: {
          listMonth: "Month List",
          listDay: "Day list",
          listWeek: "Week list",
          dayGridMonth: "Month",
          timeGridWeek: "Week",
          timeGridDay: "Day"
        },
        themeSystem: 'bootstrap',
        select: this.select,
        eventResize: this.onEventResize,
        eventDrop: this.onEventDrag,
        plugins: [ 
          bootstrapPlugin, dayGridPlugin, 
          timeGridPlugin, listPlugin,
          interactionPlugin 
        ],
        eventClick: this.onEventClick,
        initialView: 'dayGridMonth',
        weekends: true,
        customButtons: {
          addEvent: {
            text: 'Add event',
            click: function() {
              vm.showAddNewEventForm()
            }
          }
        }
      }
    }
  }, 
  methods: {
    showAddNewEventForm() {
      this.$refs.newEvent.edit = false
      this.$modal.show('new-cal-event')
    },
    toggleWeekends() {
      this.calendarOptions.weekends = !this.calendarOptions.weekends // toggle the boolean!
    },
    handleEventClick(e) {
      this.showAddNewEventForm()
    },
    onEventClick(info) {
      let eventObj = info.event
      this.currentEvent = eventObj
    },
    onEventDrag(info) {
      this.$swal({
        title: 'Move this event?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#fc331c',
        cancelButtonColor: '#686868',
        confirmButtonText: '<i class="fas fa-expand-arrows-alt"></i>&nbsp;Yes, move!'
      }).then((result) => {
        if (result.value) {
          this.updateEventFromInfo(info)
        } else {
          info.revert()
        }
      })
    },
    onEventResize(info) {
      this.updateEventFromInfo(info)
    },
    select(selectionData) {
      this.$refs.newEvent.startDate = selectionData.start.toISOString()
      this.$refs.newEvent.endDate = selectionData.end.toISOString()
      this.$refs.newEvent.edit = false
      this.showAddNewEventForm()
      this.$refs.newEvent.setupUI()
    },
    updateEventFromInfo(info) {
      let eventId = info.event.extendedProps.dbId
      $.ajax({
        type: "PUT",
        data: {
          event_params: {
            start_date: info.event.startStr,
            end_date: info.event.endStr
          }
        },
        url: `/api/v1/calendar_events/${eventId}`
      }).fail((err) => {
        info.revert()
        this.$swal('Error', 'Unable to change this event', 'error')
      })
    }
  }
}
</script>