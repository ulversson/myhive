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