<template>
  <table
    class="cui-github-explore-nav table recycle-bin table-hover table-default">
    <tbody>
      <BinItem v-for="item in items" 
        :itemType="itemType"
        :key="item.id" 
        :item="item"
       />
    </tbody>
  </table>
</template>
<script>
import BinItem from './BinItem.vue'
import selection from '../../file_manager/mixins/selection'
export default {
  props: ['items', 'identity', 'itemType'],
  components: { BinItem },
  mixins: [ selection ],
  computed: {
    selectedItems() {
      return this.$store.state.selectedItems
    },
    isSelectedItemsEmpty() {
      return this.$store.state.selectedItems.length === 0
    },
  }
};
</script>
