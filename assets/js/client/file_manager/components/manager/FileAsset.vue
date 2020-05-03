<template>
  <tr class='asset'>
    <td style='max-width: 40px; width: 40px' data-type="fileAsset" :data-id="fileAsset.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" @click="emitAssetChecked($event, fileAsset.id, 'asset')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon text-secondary">
      <i :class="fileAsset.icon"></i>
    </td>
    <td class="cui-github-explore-nav-content">
      <a href="#" class="cui-github-explore-nav-link">
        {{ fileAsset.name }}
      </a>
    </td>
    <td class="cui-github-explore-nav-descr">{{ fileAsset.caption}}</td>
    <td class="cui-github-explore-nav-time">{{ dateAgo }}</td>
    <FileAssetActions :fileAsset="fileAsset" />
  </tr>
</template>
<script>
import FileAssetActions from '../actions/FileAssetActions.vue'
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['fileAsset'],
  mixins: [currentFolder],
  components: { FileAssetActions },
  methods: {
    emitAssetChecked(evt, elementId, elemetType) {
      let isChecked = $(evt.target).prop('checked')
      this.managerComponent.$emit('checked.folder', {
        checked: isChecked,
        type: elemetType,
        id: elementId
      })
    }
  },
  computed: {
    dateAgo() {
      return moment(this.fileAsset.updated_at).fromNow()
    }
  }
}
</script>