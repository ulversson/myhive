<template>
  <table
    class="cui-github-explore-nav table table-hover col-md-10 col-sm-6 col-xs-4 table-default">
    <tbody>
      <BinItem v-for="item in items" 
        :key="item.id" :item="item" />
    </tbody>
  </table>
</template>
<script>
import BinItem from './BinItem.vue'
export default {
  props: ['items', 'identity'],
  components: { BinItem }
};
</script>
