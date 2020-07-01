<template>
  <div class='row'>
    <div class='col-md-12'>
      <a class='btn btn-sm btn-primary mb-5'
        data-toggle='tooltip'
        data-title='Add new calendar event'
        @click="showAddNewEventForm"
        data-placement='top'>
        <i class='fas fa-calendar-plus'></i>
        &nbsp;Add new event
      </a>
      <NewEvent />
      <FullCalendar :options="calendarOptions" />
    </div>
  </div>
</template>
<script>
import FullCalendar from '@fullcalendar/vue'
import NewEvent from './components/NewEvent.vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import bootstrapPlugin from '@fullcalendar/bootstrap'
import interactionPlugin from '@fullcalendar/interaction'

import 'bootstrap/dist/css/bootstrap.css'

export default {
  components: {
    FullCalendar, NewEvent
  },
  created() {
    UI.setup()
  },
  data() {
    return {
      calendarOptions: {
        draggable: true,
        editable: true,
        selectable: true,
        selectMirror: true,
        firstDay: 1,
        nowIndicator: true, 
        headerToolbar: {
          left  : 'prev,next today',
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
        select: this.handleEventClick,
        plugins: [ 
          bootstrapPlugin, dayGridPlugin, 
          timeGridPlugin, listPlugin,
          interactionPlugin 
        ],
        initialView: 'dayGridMonth',
        weekends: true
      }
    }
  }, 
  methods: {
    showAddNewEventForm() {
      this.$modal.show('new-cal-event')
    },
    toggleWeekends() {
      this.calendarOptions.weekends = !this.calendarOptions.weekends // toggle the boolean!
    },
    handleEventClick(e) {
      this.showAddNewEventForm()
    }
  }
}
</script>