<template>
  <a class="nav-link"
    href="javascript: void(0);"
    data-toggle="tab"
    :data-target="`#item${identity}`"
    role="tab">
    <i class='fal fa-calendar-alt'
      :style="`color: ${textColor} !important`">
    </i>&nbsp;
    {{ day() }}
  </a>
</template>
<script>
import settings from '../../file_manager/mixins/settings'
export default {
  mixins: [settings],
  methods: {
     day() {
      return moment(this.date).format('ll')
    }
  },
  props: ['identity', 'date']
}
</script>