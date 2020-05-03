<template>
   <tr class='dir'>
    <td style='max-width: 40px; width: 40px' data-type="folder" :data-id="directory.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" @click="emitDirectoryChecked($event, directory.id, 'folder')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon text-secondary" @click="openFolder(directory.id)">
      <i class="fa fa-folder"></i>
    </td>
    <td class="cui-github-explore-nav-content" @click="openFolder(directory.id)">
      <a href="#" class="cui-github-explore-nav-link">
        {{ directory.name }}
      </a>
    </td>
    <td class="cui-github-explore-nav-descr">{{directory.description}}</td>
    <td class="cui-github-explore-nav-time">{{ this.dateAgo }}</td>
    <FolderActions />
  </tr>
</template>
<script>
import FolderActions from '../actions/FolderActions.vue'
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['directory'],
  mixins: [currentFolder],
  components: { FolderActions },
  methods: {
    emitDirectoryChecked(evt, elementId, elemetType) {
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
      return moment(this.directory.updated).fromNow()
    }
  }
}
</script>