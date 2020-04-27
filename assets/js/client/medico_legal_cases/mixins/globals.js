export default {
  methods: {
    capitalize(s) {
      if (typeof s !== 'string') return ''
      return s.charAt(0).toUpperCase() + s.slice(1)
    },
    parsedDate(date) {
      return moment(date, 'YYYY-MM-DD').format('DD/MM/YYYY')
    },
    parsedDateTime(date) {
      return moment(date).format('DD/MM/YYYY HH:MM')
    },
  }
}