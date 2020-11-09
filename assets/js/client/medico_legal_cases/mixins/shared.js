export default {
  computed: {
    patientName() {
      if (!this.medicoLegalCase) return ''
      return `${this.medicoLegalCase.patient.first_name} ${this.medicoLegalCase.patient.last_name}`
    },
    claimantName() {
      if (!this.medicoLegalCase) return ''
      if (this.medicoLegalCase.claimant === null) return ''
      return `${this.medicoLegalCase.claimant.first_name} ${this.medicoLegalCase.claimant.last_name}`
    },
    isAdmin() {
      return this.$store.state.role === "super_admin" || this.$store.state.role === "admin"
    },
    isArchiver() {
      return this.$store.state.role === "archiver"
    }
  },
  methods: {
    hasAddress(addressable) {
      let addressablitem = this.medicoLegalCase[addressable];
      if (addressablitem === null) {
        return false
      } else {
        return addressablitem.addresses.length > 0
      }
    }
  }
}
