<template>
  <div class='other-calendar col-12'>
    <label>Select user below to load calendar</label>
    <select class="form-control mb-2" 
      data-url='/api/v1/users/search'
      style="width: 50%; margin-bottom: 20px"
      id="user-search"
      placeholder="Select users to load calendar" />
    <p>
      <FullCalendar :options="calendarOptions" 
        style='width: 100%'
        ref='other_cal'/>
    </p>
  </div>
</template>
<script>
import calendarEvent from '../mixins/calendarEvent'
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import bootstrapPlugin from '@fullcalendar/bootstrap'
import interactionPlugin from '@fullcalendar/interaction'

export default {
  mixins: [calendarEvent],
  components: { FullCalendar },
  data() {
    return {
      calendarUserId: null,
      calendarOptions: {
        editable: false,
        selectMirror: false,
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
  mounted() {
    UI.autocompleteSearch('select#user-search', false)
    this.bindOnSelect2Change()
    $(document).on('shown.bs.tab', () => {
      this.calendar.updateSize()
    })
  },
  computed: {
    calendar() {
      return this.$refs.other_cal.getApi()
    }
  },
  methods: {
    bindOnSelect2Change() {
      $('select#user-search').on('select2:select', () => {
        let userId = $('select#user-search').val()
        if (userId) {
          this.loadEventsForUser(userId)
        }
      })
    }
  }
}
</script>
<style>
div.other-calendar .select2 {
  margin-bottom: 25px
}
div.other-calendar .select2 {
  width: 50% !important;
}
</style>