<template>
  <tr>
    <td style="max-width: 40px; width: 40px" data-type="folder">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" />
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon"
      :style="`color: ${textColor} !important`"
      @click="getItem()">
      <i :class="item.icon"></i>
    </td>
    <td class="cui-github-explore-nav-content">
      <a href="#" class="cui-github-explore-nav-link" @click="getItem">
        {{ item.name }}
      x</a>
    </td>
    <td class="cui-github-explore-nav-descr text-muted">Origin: {{ origin }}</td>
    <td class="cui-github-explore-nav-time">{{ deleted }}</td>
    <BinActions :item="item" 
      :downloadLink="downloadLink" />
  </tr>
</template>
<script>
import settings from "../../file_manager/mixins/settings";
import BinActions from './BinActions.vue'
export default {
  components: { BinActions },
  mixins: [settings],
  props: ["item", "itemType"],
  methods: {
    getItem() {
      window.location.href = this.downloadLink
    }
  },
  computed: {
     downloadLink() {
      switch (this.itemType) {
        case 'file':
          return `/downloads/${this.item.id}`
        case 'folder':
          return ''
      }
    },
    origin() {
      return this.item.original_folder
    },
    deleted() {
      return moment.utc(this.item.deleted_at)
        .tz('Europe/London')
        .format('DD/MM/YYYY HH:mm')
    }
  }
};
</script>
