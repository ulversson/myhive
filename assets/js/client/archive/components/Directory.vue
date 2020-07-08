<template>
  <tr>
    <td style='max-width: 40px; width: 40px' data-type="folder" :data-id="directory.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" 
          @click="emitDirectoryChecked($event, directory.id, 'folder')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon">
      <i :class="directory.icon"    
      :style='`color: ${textColor} !important`'>
      </i>
    </td>
    <td class="cui-github-explore-nav-content">
      <a href="#" class="cui-github-explore-nav-link">
        {{directory.name}}
      </a>
    </td>
    <td class="cui-github-explore-nav-descr text-muted">
      {{directory.description}}
    </td>
    <td class="cui-github-explore-nav-time">
      {{ dateAgo }}
    </td>
    <FolderActions :directory="directory" 
      :currentFolder="currentFolder"/>
  </tr>
</template>
<script>
import FolderActions from '../../file_manager/components/actions/FolderActions.vue'
export default {
  props: ['directory', 'currentFolder', 'textColor'],
  components: { FolderActions },
  computed: {
    dateAgo() {
      return moment.utc(this.directory.updated).fromNow()
    }
  }
}
</script>