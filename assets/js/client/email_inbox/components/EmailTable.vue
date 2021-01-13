<template>
  <table class="table table-hover table-striped">
    <tbody v-for="(entry, index) in entries">
      <EmailRow :entry="entry" />
    </tbody>
  </table>
</template>
<script setup>
import EmailRow from './EmailRow.vue' 
export default {
	props: ['entries'],
	components: { EmailRow }
}
</script>
