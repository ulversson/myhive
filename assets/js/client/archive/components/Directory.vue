<template>
  <tr>
    <td style='max-width: 40px; width: 40px' data-type="folder" :data-id="directory.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" 
          @click="emitDirectoryChecked($event, directory.id, 'folder')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon"
      @click="openFolder(directory.id)" >
      <i :class="directory.icon"    
        :style='`color: ${textColor} !important`'>
      </i>
    </td>
    <td class="cui-github-explore-nav-content"
      @click="openFolder(directory.id)">
      <a href="#" class="cui-github-explore-nav-link" v-html="highlight()">
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
import selection from '../../file_manager/mixins/selection'
import FolderActions from '../../file_manager/components/actions/FolderActions.vue'
export default {
  props: ['directory', 'currentFolder', 'textColor', 'highlightFilter'],
  components: { FolderActions },
  mixins: [selection],
  computed: {
    managerComponent() {
      return this.$root.$children[0]
    },
    dateAgo() {
      return moment.utc(this.directory.updated).fromNow()
    },
     dirName() {
      if (this.directory.not_viewed_file_count === 0)
        return this.directory.name
      else 
        return `${this.directory.name}&nbsp;<span class='badge badge-danger'>${this.directory.not_viewed_file_count}</span>`
    }
  },
  methods: {
    openFolder(folderId) {
      this.$parent.setCurrentFolder(folderId)
    },
    highlight() {
      if(this.$attrs.higlightFilter === "") {
        return this.dirName
      }
      return this.directory.name.replace(new RegExp(this.$attrs.higlightFilter, "gi"), match => {
        return '<span class="highlightText">' + match + '</span>'
      })  
    }
  }
}
</script>