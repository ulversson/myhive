<template>
	<div class='attachment form-group' style="display: table-row">
		<label class="mr-3 cui-utils-control cui-utils-control-checkbox">
			<input type="checkbox"
				class='attachment' :value="attachment.id"> 
			<span class="cui-utils-control-indicator"></span>
		</label>
		&nbsp;
		<a href='javascript:void(0)' 
			class='ml-3 cui-utils-link-underlined cui-utils-link-blue'
			@click="downloadAttachment">{{ attachment.name }}
		</a>
		<span>{{ this.size }}</span>
	</div>
</template>
<script>
	import download from '../../../download-ajax'
  export default {
		props: ['attachment', 'messageId', 'textColor'],
	  methods: {
			downloadData() {
			 return `data:${this.attachment.contentType};base64,${this.attachment.contentBytes}`
		 },
		 async downloadAttachment() {
			 try {
					download(this.downloadData(), this.attachment.name, this.attachment.contentType)
				} catch (ex) {
					console.log(ex)
				}
		 }
		},
	 computed: {
		 selectedAttachments() {
			 return $("input.attachment :checked")
		 },
		 jwt() {
			 return window.localStorage.getItem('msJwt')
		 },
		 size() {
			 return Fn.humanFileSize(this.attachment.size)
		 }
	 }
 }
</script>
