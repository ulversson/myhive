<template>
  <div class="manager-content">
    <table class="cui-github-explore-nav table table-hover col-md-12 col-sm-6 col-xs-4 table-default">
      <tbody>
        <ChildDirectory :directory="directory" ref="dirs"
          :highlightFilter="filter"
          :currentFolder="currentFolder"
          v-for="directory in filteredDirectories" 
          :key="directory.id"/>
        <FileAsset :fileAsset="fileAsset" ref="files"
          v-for="fileAsset in assets" 
          :highlightFilter="filter"
          :currentFolder="currentFolder"
          :key="fileAsset.id">
        </FileAsset>
      </tbody>
    </table>
    <Alert message="This folder is currently empty" 
      v-if="showAlert"/>
  </div>  
</template>
<script>
import globals from '../../medico_legal_cases/mixins/globals'
import moment from 'moment'
import currentFolder from '../mixins/currentFolder'
import shared from '../../medico_legal_cases/mixins/shared'
import ChildDirectory from './manager/ChildDirectory.vue'
import FileAsset from './manager/FileAsset.vue'
import Alert from './Alert.vue'
export default {
  data() {
    return {
      selectedItems: []
    }
  },
  computed: {
    showAlert() {
      return this.directories.length === 0 && this.assets.length === 0
    },
    newItemsCount() {
      return this.assets.filter((asset)=> {
        return asset.view_counts === 0
      }).length
    },
    filteredDirectories() {
      if (this.isAdmin) {
        return this.directories
      } else {
        return this.directories
          .filter(child => child.folder_type !== "medico_legal_case_admin")
      }
    },
  },
  props: ['directories', 'currentFolder', 'assets', 'filter'],
  mixins: [currentFolder, shared, globals],
  components: { ChildDirectory, FileAsset, Alert }
}
</script>