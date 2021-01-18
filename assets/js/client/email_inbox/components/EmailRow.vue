<template>
	<tr>
    <td>
      <label class="cui-utils-control cui-utils-control-checkbox">
				<input type="checkbox"
					:data-id="entry.id" @click="emitChecked($event)"> 
				<span class="cui-utils-control-indicator"></span>
			</label>
    </td>
    <td class="mailbox-name">
      <a href="javascript:void(0)">{{ entry.sender_name }} </a>
    </td>
    <td class="mailbox-subject"  style='cursor: pointer !important'
			 @click.prevent='expand'>
      <b v-if="entry.viewed === false">{{entry.subject}}</b>
			<span class='subject' v-if="entry.viewed">{{ entry.subject }}</span>
    </td>
    <td class="mailbox-attachment" v-if="!entry.has_attachments"></td>
		<td class="mailbox-attachment" v-if="entry.has_attachments"  
			style='cursor: pointer !important'
			@click.prevent="showAttachments">
			<i class="fal fa-paperclip"></i>
		</td>
    <td class="mailbox-date">{{ fromNow }}</td>
		<Attachments :message_id="entry.message_id"
			 v-if="entry.has_attachments"  ></Attachments>
		<td>
			<i :class='chevronIcon' 
				style='color: gray; cursor: pointer' 
				@click="expand"></i>
		</td>
  </tr>
</template>
<script>
import Attachments from './Attachments.vue'
	export default {
	components: {
    Attachments
	},
  props: ['entry'],
		methods: {
			expand() {
				this.$root.$emit('setExpand', this.entry)
			},
			emitChecked(evt) {
				let isChecked = $(evt.target).prop('checked')
      	this.$root.$emit('checked.email', {
        	checked: isChecked,
        	id: this.entry.id
      	})
			},
			showAttachments() {
				this.$modal.show(`${this.entry.message_id}-attachment-modal`)
			}
		},
		updated() {
			$("[data-toggle=tooltip]").tooltip()
		},
		computed: {
			chevronIcon() {
				return this.entry.preview_visible ? `fal fa-chevron-down` : `fal fa-chevron-up`
			},
			fromNow() {
				return moment(this.entry.received_at).fromNow()
			}
		}
	}
</script>
