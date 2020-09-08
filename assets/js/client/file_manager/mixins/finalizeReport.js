export default {
  methods: {
    isReportDirectory(directory) {
      return directory.name.match("Report") || directory.name.match("report") 
            || directory.folder_type.match("report")
    },
    disableCaseNotificationRequest() {
      let mlcId = localStorage.getItem('currentMedicoLegalCaseId')
      $.ajax({
        url: `/api/v1/medico_legal_cases/${mlcId}/disable_notification`,
        type: "PATCH",
        data: {
          id: mlcId,
          "_method": "patch"
        }
      }) 
    },
    finalizeReportPrompt() {
      this.$swal({
        title: 'Is this your final report for this case?',
        text: "Clicking 'Yes' will disable all further notifications for this case",
        icon: 'question',
        showCancelButton: true,
        cancelButtonText: "No",
        confirmButtonText: 'Yes'
      }).then((result) => {
        if (result.value) {
          this.disableCaseNotificationRequest()
        }
      })
    }
  }
}