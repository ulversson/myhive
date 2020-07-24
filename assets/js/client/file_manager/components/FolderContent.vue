<template>
  <div class="manager-content">
    <table class="cui-github-explore-nav table table-hover col-9 table-default">
      <tbody>
      <ChildDirectory :directory.sync="directory" ref="dirs"
        :highlightFilter="filter"
        :currentFolder="currentFolder"
        v-for="directory in orderedDirectories" 
        :key="directory.id"/>
      <FileAsset :fileAsset.sync="fileAsset" ref="files"
        v-for="fileAsset in orderedAssets" 
        :highlightFilter="filter"
        :currentFolder="currentFolder"
        :key="fileAsset.id">
      </FileAsset>
      </tbody>
    </table>
    <Alert message="This folder is currently empty" v-if="showAlert"/>
  </div>  
</template>
<script>
import { mapState } from 'vuex'
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
    ...mapState(['column', 'order']),
    orderedDirectories() {
      if (this.column === 'name' && this.order === 'asc') {
        return this.filteredDirectories.sort((a, b) => this.sortFunction(a,b))
      } else if (this.column === 'name' && this.order === 'desc') {
        return this.filteredDirectories.sort((a, b) => this.sortFunction(a,b)).reverse()
      } else if (this.column === 'date' && this.order === 'asc') {
        return this.filteredDirectories.sort((a, b) => this.sortDateFunction(a, b, 'updated'))
      } else if (this.column === 'date' && this.order === 'desc') {
        return this.filteredDirectories.sort((a, b) => this.sortDateFunction(b,a, 'updated'))
      }
    },
    orderedAssets() {
      if (this.column === 'name' && this.order === 'asc') {
        return this.assets.sort((a, b) => this.sortFunction(a,b))
      } else if (this.column === 'name' && this.order === 'desc') {
        return this.assets.sort((a, b) => this.sortFunction(a,b)).reverse()
      } else if (this.column === 'date' && this.order === 'asc') {
        return this.assets.sort((a, b) => this.sortDateFunction(a, b, 'updated_at'))
      } else if (this.column === 'date' && this.order === 'desc') {
        return this.assets.sort((a, b) => this.sortDateFunction(b,a, 'updated_at'))
      }
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