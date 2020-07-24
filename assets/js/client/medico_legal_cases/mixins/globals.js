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
   sortFunction(a, b) {
      if(a.name < b.name) { return -1 }
      if(a.name > b.name) { return 1 }
      return 0
    },
    sortDateFunction(a, b, column) {
      return function (a, b) {
        debugger
        let dateA = moment(a[column]).toDate()
        let dateB = moment(b[column]).toDate()
        return dateA >= dateB ? 1 : -1
      }
    }
  }
}