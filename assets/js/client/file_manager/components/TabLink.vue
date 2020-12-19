<template>
  <a
    class="nav-link nav-folder btn-tooltip"
    :class="showTab(tab) ? 'active' : ''"
    href="javascript:void(0)"
    :data-title="tab.name"
    @click="
      setCurrentFolder(tab.id);
      setCurrentTab(tab.id);
    "
    data-delay='{"show":"2000", "hide":"500"}'
    data-toggle="tab"
    role="tab"
    :data-target="`#f${tab.id}`">
    <i :class="folderIcon(tab)" :style="`color: ${textColor} !important`"></i>
    &nbsp;{{ tab.name }}
  </a>
</template>
<script>
export default {
	props: [
		'tab', 'textColor', 'currentFolder', 
		'setCurrentFolder', 'setCurrentTab'
	],
  data() {
    return {
      currentTabId: 0,
    };
  },
  methods: {
    folderIcon(tab) {
      if (tab.folder_type === "medico_legal_case") {
        if (this.currentFolder.id === tab.id) return "fas fa-folder-open";
        else return "fas fa-folder";
      } else {
        return tab.icon;
      }
    },
    showTab(tab) {
      return tab.id === this.currentTabId;
    },
  },
};
</script>