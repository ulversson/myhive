<template>
	<modal
    :name="`${message_id}-attachment-modal`"
    :min-width="200"
    :min-height="350"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    width="60%"
    height="auto">
		<h2>Test</h2>
	</modal>
</template>
<script>
	export default {
		props: ['message_id']
	}
</script>
