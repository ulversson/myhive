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
	components: { TabLink },
	props: [
		'children', 'textColor', 'currentFolder', 
		'setCurrentFolder', 'setCurrentTab'
	]
}
</script>