<template>
<div class='delete-button'>
  <button type="button" class="btn icon-btn btn-sm btn-outline-danger btn-rounded" 
    @click='deleteRow'>
    <span class="fa fa-trash-alt"></span>
  </button>
</div>
</template>
<script>
export default {
  props: ['row'],
  computed: {
    table() {
      return this.$root.$children[0].$refs.table
    }
  },
  methods: {
    deleteRow() {
      let vm = this
      UI.runConfirmedAction(
        'fas fa-trash-alt', 
        'DELETE',
        'Remove entry', 
        'You will not be able to revert this action',
        `/api/v1/time_sheet/${this.$attrs.data.id}`,
        () => {
          this.table.$refs["time-sheet"].refresh()
        },() => {

        }, vm)
    }
  }
}
</script>