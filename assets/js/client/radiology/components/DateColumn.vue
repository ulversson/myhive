<template>
  <div class='time-radiology'>
    <p class="text-info mb-0">
      <i class='fal fa-calendar text-info'></i>&nbsp;{{this.columnTime}}
    </p>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  computed: {
    columnTime() {
      return moment(this.$attrs.data["Study Date"])
        .format('DD MMM YYYY')
    }
  },
  props: ['row']
}
</script>