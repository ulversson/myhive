<template>
  <table class="table table-striped nowrap dataTable no-footer dtr-inline collapsed">
    <tbody>
			<template v-for="(entry, index) in entries" >
				<EmailRow :entry.sync="entry"/>
				<EmailExpand :entry.sync="entry" ref="accordion" />
			</template>
    </tbody>
  </table>
</template>
<script setup>
import EmailExpand from './EmailExpand.vue'
import EmailRow from './EmailRow.vue' 
export default {
	props: ['entries'],
	components: { EmailRow, EmailExpand }
}
</script>