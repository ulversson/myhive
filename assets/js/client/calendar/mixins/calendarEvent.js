export default {
  methods: {
    dbEventToFullcalendar(dbEvent) {
      return {
        start: dbEvent.start_date,
        end: dbEvent.end_date,
        color: dbEvent.color,
        calColor: dbEvent.color,
        allDay: dbEvent.all_day,
        title: dbEvent.name,
        dbId: dbEvent.id,
        description: dbEvent.description
      }
    },
    loadEvents() {
      $.getJSON(`/api/v1/calendar_events`, (jsonRes) => {
        jsonRes.data.forEach((calEv, index) => {
          this.$refs.cal.getApi()
            .addEvent(this.dbEventToFullcalendar(calEv))
        })
        this.$store.commit('setRole', jsonRes.role[0])
      })
    },
    loadEventsForUser(userId) {
      this.removeEvents()
      let requestUrl  = `/api/v1/calendar_events/for_user/${userId}`
      $.getJSON(requestUrl, (jsonRes) => {
        jsonRes.data.forEach((calEv, index) => {
          this.$refs['other_cal'].getApi()
            .addEvent(this.dbEventToFullcalendar(calEv))
        })
        this.calendarUserId = userId

        this.calendar.render()
      })
    },
    removeEvents() {
      this.calendar.getEvents().forEach((element, index) => {
        this.calendar.getEventById(element.id).remove()
      })
    },
    setupUI() {
      $('div.rimain button[name="riedit"]')
        .addClass('btn btn-sm btn-warning')
      $('div.rimain button[name="ridelete"]')
        .addClass('btn btn-sm btn-danger')
      $('input.risavebutton')
        .addClass('btn btn-sm btn-info')
    },
  }
}