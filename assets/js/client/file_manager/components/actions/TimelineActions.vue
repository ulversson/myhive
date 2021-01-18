<template>
	<div class='dropdown cui-github-explore-sort-option timeline-actions'>
	   <button type="button"
      class="btn dropdown-toggle btn-timeline same-width"
      style="height: 39.84px;"
      data-toggle="dropdown"
      aria-expanded="false">
			<i class='fas fa-analytics' :style="`color: ${textColor}`"></i>&nbsp;
      Timeline
    </button>
		<ul class="dropdown-menu" aria-labelledby="" role="menu">
      <li style="line-height: 35px" class='new-stage'>
        <a class="dropdown-item btn-new-stage"
          data-toggle="tooltip"
          data-placement="top"
					@click="addStage">
          <i class='fal fa-tasks'></i>&nbsp;
          Add new stage
        </a>
      </li>
      <li style="line-height: 35px" class="reset-stage">
        <a class="dropdown-item btn-reset-stage"
					@click="resetStages">
          <i class='fal fa-redo'></i>&nbsp;
          Restore default
        </a>
      </li>
		</ul>
	</div>
</template>
<script>
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