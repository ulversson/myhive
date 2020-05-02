<template>
  <table class="cui-github-explore-nav table table-hover col-9 table-default">
    <tbody>
      <tr v-for="directory in directories" :key="directory.id">
        <td style='max-width: 40px; width: 40px'>
          <label class="cui-utils-control cui-utils-control-checkbox">
            <input type="checkbox">
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
        <td class="cui-github-explore-nav-time">{{ dateAgo(directory) }}</td>
        <FolderActions />
      </tr>
    </tbody>
  </table>
</template>
<script>
import moment from 'moment'
import currentFolder from '../mixins/currentFolder'
import FolderActions from './actions/FolderActions.vue'
export default {
  props: ['directories', 'currentFolder'],
  mixins: [currentFolder],
  components: { FolderActions },
  methods: {
    dateAgo(directory) {
      return moment(directory.updated).fromNow()
    }
  }
}
</script>