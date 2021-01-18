<template>
	<table class='table-borderless' style='width: 100%'>
		<tbody>
			<tr>
				<td style='text-align: right'>From: </td>
				<td><{{entry.sender_name}}>&nbsp;
					<a :href="`mailto:${entry.sender}`">{{entry.sender}}</a>
				</td>
			</tr>
			<tr>
				<td style='text-align: right'>To:</td>
				<td v-html="allRecipients()"></td>
			</tr>
			<tr>
				<td style='text-align: right'>Received:</td>
				<td>{{ receivedDate }}</td>
			</tr>
			<tr v-if="entry.has_attachments" @click="showAttachments">
				<td style='text-align: right'>Attachment/s:</td>
				<td><i class='fal fa-paperclip'></i></td>
			</tr>
			<tr>
				<td style='text-align: right'>Actions:</td>
				<td>
					<a data-toggle="tooltip" data-title="View in Outlook online" 
						@click="viewInOutlook"
						class="btn btn-icon btn-xs btn-outline-primary mr-2 mb-2 btn-rounded" 
						data-original-title="" title=""><i class="fal fa-external-link-alt"></i>
					</a>
					<a data-toggle="tooltip" data-title="Save email content" 
						@click="showSaveContent"
						class="btn btn-icon btn-xs btn-outline-success mr-2 mb-2 btn-rounded" 
						data-original-title="" title=""><i class="fal fa-long-arrow-down"></i>
					</a>
				</td>
			</tr>
			<SaveContent :entry="entry" :message_id="entry.message_id" />
		</tbody>
	</table>
</template>
<script>
  import SaveContent from './SaveContent.vue'
	export default {
		props: ['entry'],
		components: { SaveContent },
		methods: {
			showAttachments() {
				this.$modal.show(`${this.entry.message_id}-attachment-modal`)
			},
			allRecipients() {
				return this.entry.to_receipients.split(",").map((rcpt, index) => {
					return `<${this.addresses[index]}>&nbsp;<a href='mailto:${rcpt}'>${rcpt}</a>`
				}).join(",")
			},
			viewInOutlook() {
				window.open(this.entry.web_link, "_blank")
			},
			showSaveContent() {
				this.$modal.show(`${this.entry.message_id}-save-content-modal`)
			}
		},
		computed: {
			names() {
				return this.entry.recipient_names.split(",")
			},
			addresses() {
				return	this.entry.to_receipients.split(",")
			},
			receivedDate() {
				return moment(this.entry.received_at).format('DD/MM/YYYY HH:mm')

			}
		}
	}
</script>
