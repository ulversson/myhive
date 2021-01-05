<template>
	<div class='add-stage'>
		<button class="btn btn-sm btn-myhive mb-2"
			@click="addStage">
			<i class='fas fa-tasks'></i>&nbsp;
			Add timeline stage
		</button>
		<button class="btn btn-sm btn-warning mb-2"
			@click="resetStages">
			<i class='fas fa-redo'></i>&nbsp;
			Reset to default
		</button>
	</div>
</template>
<script>
// @ts-nocheck
import caseStatus from '../../mixins/caseStatus'
import Swal from 'sweetalert2'
export default {
	mixins: [caseStatus],
	computed: {
		tooltip() {
			return "New stage be added as the last item in the timeline.  You can drag it by the icon to move to the desired position"
		},
		mlcId() {
			return window.localStorage.getItem('currentMedicoLegalCaseId')
		}
	},
	methods: {
		stageName() {
			return Swal.getPopup().querySelector('input.swal2-input').value
		},
		addStage() {
			this.$swal({
				title: "Enter stage name",
				text: this.tooltip,
				focusConfirm: false,
      	showCancelButton: true,
				input: 'text',
				preConfirm: (value) => {

					if (value.length === 0) {
						Swal.showValidationMessage(`Name field cannot be empty`)
						this.$swal('Error', 'Name cannot be empty', 'error')
						return false
					} else {
						return {name: this.stageName()}
					}
      }
			}).then((result) => {
				if (result.value && result.value.name) {
					this.createMlcStage(result.value.name)
				} 
			})
		},
		createMlcStage(name) {
			$.ajax({
				url: `/api/v1/timeline`,
				type: 'POST',
				data: {
					medico_legal_case_id: this.mlcId,
					name: name
				}
			}).done((jsRes) => {
				window.location.reload(true)
			}).catch(err => {
				this.$swal('Error', 'Unable to add this stage', 'error')
			})
		},
		resetStages() {
			debugger
			 UI.runConfirmedAction(
        'fas fa-redo', 
        'DELETE',
        'Restore default stages',
        'The progress for this case will be recalculated',
        `/api/v1/timeline/${this.mlcId}/reset`, () => {
          window.location.reload(true)
        }
      )
		}
	}
}
</script>