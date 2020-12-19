<template>
  <ul class="nav nav-tabs" role="tablist" id="folder-tabs">
    <li class="nav-item" :key="index" v-for="(tab, index) in children">
      <TabLink
				:currentFolder="currentFolder"
				:setCurrentFolder="setCurrentFolder"
				:setCurrentTab="setCurrentTab"
				:tab="tab" 
				:textColor="textColor"/>
    </li>
  </ul>
</template>
<script>
import TabLink from './TabLink.vue'
export default {
	data() {
    return {
      currentTabId: 0,
    };
  },
	created() {
		this.$root.$on('setTab', (id) => {
			this.currentTabId = id
		})
	},
	components: { TabLink },
	props: [
		'children', 'textColor', 'currentFolder', 
		'setCurrentFolder', 'setCurrentTab'
	]
}
</script>