<template>
  <div class="tab-content">
    <div class="tab-pane" :id="`item${objectKey(item.date)}`"
      v-for="(item,index) in groupedItems" :key="objectKey(item.date)"
      :class='index === 0 ? "active": ""'>
        <BinItems :items="item.items" :identity="objectKey(item.date)" />
    </div>
  </div>
</template>
<script>
import BinItems from './BinItems.vue'
export default {
  props: ['groupedItems'],
  components: { BinItems },
  methods: {
    objectKey(date) {
      return moment(date)
        .toDate()
        .getTime()
        .toString();
    }
  }
};
</script>
