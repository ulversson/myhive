<template>
  <tr>
    <td style="max-width: 40px; width: 40px" class='item'>
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" :data-id="item.id" 
            @click="emitChecked($event)"/>
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
      </a>
    </td>
    <td class="cui-github-explore-nav-descr text-muted">Origin: {{ origin }}</td>
    <td class="cui-github-explore-nav-time">{{ deleted }}</td>
    <BinActions :item="item" :itemType="itemType" />
  </tr>
</template>
<script>
import settings from "../../file_manager/mixins/settings"
import download from '../../file_manager/mixins/download'
import selection from '../../file_manager/mixins/selection'
import binDownload from '../mixins/binDownload'
import BinActions from './BinActions.vue'
export default {
  components: { BinActions },
  mixins: [settings, download, selection, binDownload ],
  props: ["item", "itemType"],
  methods: {
    emitChecked(ev) {
      switch (this.itemType) {
        case 'file':
          this.emitAssetChecked(ev, this.item.id)
        break;
        case 'folder':
          this.emitDirectoryChecked(ev, this.item.id, 'folder');
      }
    },
    emitAssetChecked(evt, elementId) {
      let isChecked = $(evt.target).prop('checked')
      this.managerComponent.$emit('checked.folder', {
        checked: isChecked,
        type: 'file',
        id: elementId
      })
    }
  },
  computed: {
    managerComponent() {
      return this.$parent
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
