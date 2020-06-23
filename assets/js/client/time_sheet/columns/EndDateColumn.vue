<template>
  <div class='time-start-date' style='font-size: 13px'>
    <p class="text-uppercase">
      {{this.columnTime}}
    </p>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  computed: {
    columnTime() {
      return moment(this.$attrs.data.end_date)
        .format('DD/MM/YYYY HH:mm')
    }
  },
  props: ['row']
}
</script>