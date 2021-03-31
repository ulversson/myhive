export default {
	methods: {
		clearAutosave() { 
			if (window.intervalToken) {
				clearInterval(window.intervalToken)
				window.intervalToken = null
			}
			if (window.refreshToken) {
				clearInterval(window.refreshToken)
				window.refreshToken = null
			}
		},
		hideModal() {
			this.$swal({
        title: 'Close this form?',
        text: "Make sure all your changes has been saved before closing",
				icon: 'question',
        showCancelButton: true,
        confirmButtonText: `Close`,
      }).then((result) => {
        if (result.isConfirmed) {
          this.clearAutosave()
					this.$modal.hide("new-report")
        }
      })
		}
	}
}