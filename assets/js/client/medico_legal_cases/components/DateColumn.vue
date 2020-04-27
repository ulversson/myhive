<template>
  <div class='time-mlc' style='font-size: 13px'>
    <p class="text-uppercase text-default">
      {{this.columnTime}}
    </p>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  computed: {
    columnTime() {
      return moment(this.$attrs.data.created_at)
        .format('DD/MM/YYYY HH:mm')
    }
  },
  props: ['row']
}
</script>