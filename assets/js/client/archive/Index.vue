<template>
  <div class='archive'
    v-cloak @drop.prevent="addFile" @dragover.prevent>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder"
      ref='headerPanel'/> 
    <h4>{{name}}</h4>
    <table class="cui-github-explore-nav table table-hover">
    <tbody>
      <Directory 
        v-for="directory in filteredDirectories" 
        :directory="directory"
        :textColor="textColor"
        :higlightFilter.sync="filter"
        :currentFolder="currentFolder"
        :key="directory.id" />
      <FileAsset :fileAsset.sync="fileAsset" 
        ref="files"
        v-for="fileAsset in filteredAssets" 
        :highlightFilter.sync="filter"
        :currentFolder.sync="currentFolder"
        :key="fileAsset.id" />
    </tbody>
  </table>
  <Alert 
    :message="alertMessage"
    v-if="showAlert" />
  </div>
</template>
<script>
import Alert from '../file_manager/components/Alert.vue'
import Header from './components/Header.vue'
import Directory from './components/Directory.vue'
import FileAsset from '../file_manager/components/manager/FileAsset.vue'
import settings from '../file_manager/mixins/settings'
import selection from '../file_manager/mixins/selection'
import uploadDrag from '../file_manager/mixins/upload-drag'
export default {
  components: { Header, Directory, FileAsset, Alert },
  mixins: [settings, selection, uploadDrag],
  data() {
    return {
      archiveRoot: null,
      directories: [],
      alertMessage: "This directory is currently empty. Click above to add new folder or upload a file",
      files: [], //upload files
      assets: [],
      filter: "",
      galleryAssets: [],
      name: "",
      currentFolder: {}
    }
  },
  created() {
    this.loadArchiveRoot()
    this.loadSettings()
    this.onDirectoryChecked()
  },
  computed: {
     filteredAssets() {
      if (this.filter === "") return this.assets
      return this.assets.filter((asset) => {
        return asset.name.toLowerCase().includes(this.filter.toLowerCase())
      })
    },
    filteredDirectories() {
      if (this.filter === "") return this.directories
      return this.directories.filter((dir) => {
        return dir.name.toLowerCase().includes(this.filter.toLowerCase())
      })
    },
    uppy()  {
      return this.$refs.headerPanel.uppy
    },
    order() {
      return this.$store.state.order
    },
    column() {
      return this.$store.state.column
    },
    showAlert() {
      return this.files.length === 0 && this.directories.length === 0
    }
  },
  methods: {
    setLoadedData(folder) {
      debugger
      this.reset()
      this.currentFolder = folder
      this.archiveRoot = folder
      folder.children.forEach(child => {
        this.directories.push(child)
      })
      folder.assets.forEach(asset => {
        this.assets.push(asset)
      })
      this.name = folder.name
      this.$store.commit('setRole', folder.roles[0])
    },
    setCurrentFolder(folderId) {
      this.$store.dispatch('setCaseFolder', {
        caseFolder: folderId
      }).then((folder) => {
        this.setLoadedData(folder)
      })
    },
    reset() {
      $("input:checked").click()
      this.assets.splice(0, this.assets.length)
      this.directories.splice(0, this.directories.length)
      this.filter = ""
      this.galleryAssets.splice(0, this.galleryAssets.length)
    },
    loadArchiveRoot() {
      $.getJSON(`/api/v1/archive?order=${this.order}&column=${this.column}`, 
        (folder) => this.setLoadedData(folder)
      )
    }
  }
}
</script>