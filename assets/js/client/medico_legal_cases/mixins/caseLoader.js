export default {
  methods: {
    loadCaseDetails(caseId) {
      return $.ajax({
        url: `/api/v1/medico_legal_cases/${caseId}`
      })
    }
  }
}