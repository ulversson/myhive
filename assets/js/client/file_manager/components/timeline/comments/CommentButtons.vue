<template>
	<div>
		<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
      style="float: right; margin-right: 10px !important;margin-bottom: 10px !important;"
      @click="hideComments()">
      <i class="far fa-times-circle"></i>&nbsp;Close
    </a>
		<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
      style="float: right; margin-right: 10px !important;margin-bottom: 10px !important;"
      @click="toggleComment()" v-if="buttonVisible">
      <i class="fas fa-ban"></i>&nbsp;Cancel add
    </a>
		<a class="btn btn-sm btn-primary pull-right mt-2 mr-2"
      style="float: right; margin-right: 10px !important;margin-bottom: 10px !important;"
      @click="save()"
			v-if="buttonVisible">
      <i class="fas fa-save"></i>&nbsp;Save
    </a>
		<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
      style="float: right; margin-right: 10px !important;margin-bottom: 10px !important;"
      @click="toggleComment()" v-if="!buttonVisible">
      <i class="fas fa-comment-medical"></i>&nbsp;Add Comment
    </a>
	</div>
</template>
<script>
export default {
	props: ['buttonVisible', 'toggleComment', 'save', 'hideComments']
}
</script>
