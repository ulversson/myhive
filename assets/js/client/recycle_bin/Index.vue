<template>
  <div class="bin-content col-12">
    <div class="nav-tabs-vertical">
      <DayTabs :groupedItems="groupedItems" />
      <TabContent :groupedItems="groupedItems" />
    </div>
  </div>
</template>
<script>
import settings from '../file_manager/mixins/settings'
import DayTabs from './components/DayTabs.vue'
import TabContent from './components/TabContent.vue'
export default {
  components: { DayTabs, TabContent },
  mixins: [settings],
  data() {
    return {
      groupedItems: () => {}
    }
  },
  created() {
    this.loadBinContent()
    this.loadSettings()
  },
  methods: {
    loadBinContent() {
      $.ajax({
        type: 'GET',
        url: `/api/v1/recycle_bin`,
        contentType: 'application/json'
      }).done((jsonRes) => {
        let grouped = Fn.groupArrayByDate(jsonRes, 'deleted_at')
        this.$set(this, 'groupedItems', grouped)
      }).catch(err => {

      })
    }
  }
}
</script>