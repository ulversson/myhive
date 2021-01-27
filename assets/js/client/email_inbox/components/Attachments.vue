<template>
	<modal
    :name="modalName"
    :min-width="200"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    width="30%"
		:height="400"
		@opened="loadAttachments"
    height="auto">
		<div class='card'>
			<div class='card-header'>
				<i class='fas fa-paperclip'></i>&nbsp;Attachments</div>
			<div class='card-body'>
				<OutgoingEmailStorage :textColor="textColor" 
					:fullTree="true"
					:preselect="'Correspondence'"
					ref="storage" :label="'Save attachments in'"/>
				<Attachment v-for="attach in attachments" 
					:attachment="attach"
					:textColor="textColor"
					:messageId="message_id" />
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
	import Attachment from "./Attachment.vue"
	import settings from '../../file_manager/mixins/settings'
	export default {
		data() {
			return {
				attachments: []
			}
		},
		props: ['message_id'],
		mixins:  [ settings ],
		computed: {
			modalName() {
				return `${this.message_id}-attachment-modal`
			},
			folderId() {
				return this.$refs.storage.selectedValue
			}, 
			postData() {
				return {
					folder_id: this.folderId,
					attachment_ids: Array.from($("input.attachment:checked")).map (a => $(a).val()),
					message_id: this.message_id
				}
			}
		},
		methods: {
			save() {
				let selected = $("input.attachment:checked").length
				if (selected === 0) {
					return this.$swal('Please select', 'At least one item needs to be selected', 'error')
				}
				if (!this.folderId) {
					return this.$swal('Please select folder', 'You must select folder to save files in', 'error')
				}
				$.post({
					url: `/api/v1/email_inbox/${this.message_id}/save_attachments`, 
					data: this.postData
				}).done((res) => {
					this.$modal.hide(this.modalName)
					this.$swal('Items saved', 'Selected items were saved!', 'success')
				})
			},
			loadAttachments()  {
				let requestUrl = encodeURI(`/api/v1/email_inbox/${this.message_id}/attachments`)
				$.getJSON(requestUrl, (jsRes) => {
					this.attachments = jsRes.data
				})
			},
			hideModal() {
				this.$modal.hide(this.modalName)
			}
		},
		components: {
			Attachment, OutgoingEmailStorage
		}
	}
</script>
