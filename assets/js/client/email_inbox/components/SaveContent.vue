<template>
	<modal
    :name="modalName"
    :min-width="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    width="30%"
		:height="400">
		<div class='card'>
			<div class='card-header'>
			<i class='fal fa-long-arrow-down'></i>&nbsp;Save email content</div>
			<div class='card-body'>
				<OutgoingEmailStorage :textColor="textColor" :fullTree="true"
					ref="storage"/>
				<span class='help-block text-muted'>Select where to save this email</span>
			</div>
			<div class='card-footer'>
				<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
      		style="float: right;margin-bottom: 20px !important;"
      		@click="hideModal()">
      		<i class="far fa-times-circle"></i>&nbsp;Close
    		</a>
				&nbsp;
				<a class="btn btn-sm btn-myhive pull-right mt-2 mr-3"
      		style="float: right;margin-bottom: 20px !important;"
      		@click="save()">
      		<i class="far fa-save"></i>&nbsp;Save
    		</a>	
			</div>
		</div>
	</modal>
</template>
<script>
	import OutgoingEmailStorage from '../../file_manager/components/email_templates/send/OutgoingEmailStorage.vue'
	import settings from '../../file_manager/mixins/settings'
	export default {
		props: ['message_id', 'entry'],
		mixins:  [ settings ],
		computed: {
			modalName() {
				return `${this.message_id}-save-content-modal`
			},
			folderId() {
				return this.$refs.storage.selectedValue
			}, 
			postData() {
				return {
					message_id: this.message_id,
					folder_id: this.folderId
				}
			}
		},
		methods: {
			save() {
				if (!this.folderId) {
					return this.$swal('Please select folder', 'You must select folder to save files in', 'error')
				}
				$.post({
					url: `/api/v1/email_inbox/${this.entry.id}/save_content`, 
					data: this.postData
				}).done((res) => {
					this.$modal.hide(this.modalName)
					this.$swal('Items saved', 'Email has been saved', 'success')
				})
			},
			hideModal() {
				this.$modal.hide(this.modalName)
			}
		},
		components: {
			OutgoingEmailStorage
		}
	}
</script>
