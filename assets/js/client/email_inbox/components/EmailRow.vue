<template>
	<tr style='cursor: pointer'>
    <td>
      <label class="cui-utils-control cui-utils-control-checkbox">
				<input type="checkbox"
					:data-id="entry.id" 
					@click="emitChecked($event)"> 
				<span class="cui-utils-control-indicator"></span>
			</label>
    </td>
    <td class="mailbox-name">
      <a href="read-mail.html">{{ entry.sender_name }} </a>
    </td>
    <td class="mailbox-subject">
      <b>{{entry.subject}}</b>
    </td>
    <td class="mailbox-attachment" v-if="!entry.has_attachments"></td>
		<td class="mailbox-attachment" v-if="entry.has_attachments">
			<i class="fas fa-paperclip"></i>
		</td>
    <td class="mailbox-date">{{ fromNow }}</td>
  </tr>
</template>
<script>
	export default {
		props: ['entry'],
		methods: {
			emitChecked(evt) {
				let isChecked = $(evt.target).prop('checked')
      	this.$root.$emit('checked.email', {
        	checked: isChecked,
        	id: this.entry.id
      	})
			}
		},
		computed: {
			fromNow() {
				return moment(this.entry.received_at).fromNow()
			}
		}
	}
</script>
