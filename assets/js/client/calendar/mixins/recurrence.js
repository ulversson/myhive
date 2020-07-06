export default {
  methods: {
    rruleGenerate() {
      let rrule = ''
      if (this.recurringRule.count == "" && this.recurringRule.until == "") {
        this.recurringRule.count = "1"
      }
      for (var key in this.recurringRule) {
        if (this.recurringRule.hasOwnProperty(key)) {
          if (this.recurringRule[key] != "") {
            rrule += key + "=" + this.recurringRule[key] + ";"
          }
        }
      }
      rrule = rrule.replace(/;\s*$/, "").toUpperCase()
      console.log(rrule)
      return rrule
    }
  }
}
