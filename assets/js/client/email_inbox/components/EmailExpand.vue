<template>
	<tr v-if='entry.preview_visible' class='accordion'>
		<td :colspan="6" >
      <div class='row'>
				<EmailHeader :entry="entry"/></EmailHeader>
				<div class="card-body col-12" 
					v-html="entry.content"
					:class="entry.preview_visible ? 'active' : ''" 
					style='background: white;max-width: 800px; overflow: scroll'>
      	</div>
			</div>
    </td>
	</tr>
</template>
<script>
	import EmailHeader from './EmailHeader.vue'
	export default {
		watch: {
			show: function(newVal, oldVal) {
				if (newVal && this.entry.viewed === false) {
					this.previewEmail()
				}
			}
		},
		components: { EmailHeader },
		computed: {
			show() {
				return this.entry.preview_visible
			}
		},
		created() {
			this.$root.$on('setExpand', (entry) => {
				if (entry.id === this.entry.id) {
					this.$set(this.entry, 'preview_visible', !this.entry.preview_visible)
				}
			})
		},
		methods: {
			previewEmail() {
				$.ajax({
					type: 'PATCH',
					url: `/api/v1/email_inbox/view_email/${this.entry.id}`
				}).done((jsRes) => {
					this.$set(this.entry, 'viewed', true)
				})
			}
		},
		props: ['entry']
	}
</script>
