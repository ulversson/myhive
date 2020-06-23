<template>
  <div class='time-start-date'>
    <p class="duration">
      <span class='badge badge-pill badge-secondary'
        style='font-size: 12px'>
        <i class='fas fa-stopwatch'></i>&nbsp;
        {{ $attrs.data.duration }}
      </span>
    </p>
  </div>
</template>
<script>
import moment from 'moment'
export default {
  props: ['row']
}
</script>