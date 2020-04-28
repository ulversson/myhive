export default {
  computed: {
    patientName() {
      return `${this.medicoLegalCase.patient.first_name} ${this.medicoLegalCase.patient.last_name}`
    },
    claimantName() {
      return `${this.medicoLegalCase.claimant.first_name} ${this.medicoLegalCase.claimant.last_name}`
    }
  },
  methods: {
    hasAddress(addressable) {
      return this.medicoLegalCase[addressable].addresses.length > 0
    }
  }
}
