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
import sort from 'fast-sort'
import { mapState } from 'vuex'
import globals from '../../medico_legal_cases/mixins/globals'
import moment from 'moment'
import currentFolder from '../mixins/currentFolder'
import shared from '../../medico_legal_cases/mixins/shared'
import ChildDirectory from './manager/ChildDirectory.vue'
import FileAsset from './manager/FileAsset.vue'
import Alert from './Alert.vue'
const naturalSort = sort.createNewInstance({
  comparer: new Intl.Collator(undefined, { numeric: true, sensitivity: 'base' }).compare,
})
export default {
  data() {
    return {
      selectedItems: []
    }
  },
  computed: {
     orderedDirectories() {
      if (this.column === 'name' && this.order === 'asc') {
        return naturalSort(this.filteredDirectories).asc(d => d.name)
      } else if (this.column === 'name' && this.order === 'desc') {
        return naturalSort(this.filteredDirectories).desc(d => d.name)
      } else if (this.column === 'date' && this.order === 'asc') {
        return sort(this.filteredDirectories).asc(d => moment(d.updated).toDate().getTime())
      } else if (this.column === 'date' && this.order === 'desc') {
        return sort(this.filteredDirectories).desc(d => moment(d.updated).toDate().getTime())
      }
    },
    orderedAssets() {
      if (this.column === 'name' && this.order === 'asc') {
        return naturalSort(this.assets).asc(d => d.name)
      } else if (this.column === 'name' && this.order === 'desc') {
        return naturalSort(this.assets).desc(d => d.name)
      } else if (this.column === 'date' && this.order === 'asc') {
        return sort(this.assets).asc(d => moment(d.updated_at).toDate().getTime())
      } else if (this.column === 'date' && this.order === 'desc') {
        return sort(this.assets).desc(d => moment(d.updated_at).toDate().getTime())
      }
    },
    showAlert() {
      return this.directories.length === 0 && this.assets.length === 0
    },
    newItemsCount() {
      return this.assets.filter((asset)=> {
        return asset.view_counts === 0
      }).length
    },
    ...mapState(['column', 'order']),
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