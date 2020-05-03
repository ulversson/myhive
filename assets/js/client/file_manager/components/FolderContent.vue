<template>
  <table class="cui-github-explore-nav table table-hover col-9 table-default">
    <tbody>
      <ChildDirectory :directory="directory" ref="dirs"
        v-for="directory in directories" :key="directory.id"/>
      <FileAsset :fileAsset="fileAsset" ref="files"
        v-for="fileAsset in assets" 
        :key="fileAsset.id"/>
    </tbody>
  </table>
</template>
<script>
import moment from 'moment'
import currentFolder from '../mixins/currentFolder'
import ChildDirectory from './manager/ChildDirectory.vue'
import FileAsset from './manager/FileAsset.vue'
export default {
  data() {
    return {
      selectedItems: []
    }
  },
  props: ['directories', 'currentFolder', 'assets'],
  mixins: [currentFolder],
  components: { ChildDirectory, FileAsset }
}
</script>