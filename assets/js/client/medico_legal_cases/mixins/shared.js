export default {
  computed: {
    patientName() {
      if (!this.medicoLegalCase) return ''
      return `${this.medicoLegalCase.patient.first_name} ${this.medicoLegalCase.patient.last_name}`
    },
    claimantName() {
      if (!this.medicoLegalCase) return ''
      return `${this.medicoLegalCase.claimant.first_name} ${this.medicoLegalCase.claimant.last_name}`
    },
    isAdmin() {
      return this.$store.state.role === "super_admin" || this.$store.state.role === "admin"
    }
  },
  methods: {
    hasAddress(addressable) {
      return this.medicoLegalCase[addressable].addresses.length > 0
    }
  }
}
