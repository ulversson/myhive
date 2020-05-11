<template>
  <div class="manager-content">
    <table class="cui-github-explore-nav table table-hover col-9 table-default">
      <tbody>
      <ChildDirectory :directory.sync="directory" ref="dirs"
        :highlightFilter="filter"
        :currentFolder="currentFolder"
        v-for="directory in directories" :key="directory.id"/>
      <FileAsset :fileAsset.sync="fileAsset" ref="files"
        v-for="fileAsset in assets" 
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
import moment from 'moment'
import currentFolder from '../mixins/currentFolder'
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
    }
  },
  props: ['directories', 'currentFolder', 'assets', 'filter'],
  mixins: [currentFolder],
  components: { ChildDirectory, FileAsset, Alert }
}
</script>