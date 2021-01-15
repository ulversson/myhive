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
		</tbody>
	</table>
</template>
<script>
	export default {
		props: ['entry'],
		methods: {
			allRecipients() {
				return this.entry.to_receipients.split(",").map((rcpt, index) => {
					return `<${this.addresses[index]}>&nbsp;<a href='mailto:${rcpt}'>${rcpt}</a>`
				}).join(",")
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
