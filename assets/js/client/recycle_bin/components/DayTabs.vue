<template>
  <ul class="nav nav-tabs tabs-vertical" role="tablist">
    <li class="nav-item"
      v-for="(item, index) in groupedItems"
      :key="objectKey(item.date)"
      :class='index === 0 ? "active": ""'>
      <TabItem :identity="objectKey(item.date)" :date="item.date" />
    </li>
  </ul>
</template>
<script>
import TabItem from './TabItem.vue'
export default {
  components: { TabItem },
  methods: {
    objectKey(date) {
      return moment(date)
        .toDate()
        .getTime()
        .toString();
    }
  },
  created() {
    console.log(this.groupedItems);
  },
  props: ["groupedItems"],
};
</script>
