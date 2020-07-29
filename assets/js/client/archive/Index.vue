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
        v-for="directory in orderedDirectories" 
        :directory="directory"
        :textColor="textColor"
        :higlightFilter.sync="filter"
        :currentFolder="currentFolder"
        :key="directory.id" />
      <FileAsset :fileAsset.sync="fileAsset" 
        ref="files"
        v-for="fileAsset in orderedAssets" 
        :highlightFilter.sync="filter"
        :currentFolder.sync="currentFolder"
        :key="fileAsset.id" />
    </tbody>
  </table>
  <Alert 
    :message="alertMessage" v-if="showAlert" />
  <Gallery :items="galleryAssets" ref="gallery" />
  </div>
</template>
<script>
import { mapState } from 'vuex'
import Alert from '../file_manager/components/Alert.vue'
import Header from './components/Header.vue'
import Directory from './components/Directory.vue'
import Gallery from '../file_manager/components/manager/file_types/Gallery.vue'
import FileAsset from '../file_manager/components/manager/FileAsset.vue'
import settings from '../file_manager/mixins/settings'
import sorting from '../file_manager/mixins/sorting'
import selection from '../file_manager/mixins/selection'
import uploadDrag from '../file_manager/mixins/upload-drag'
import imageGallery from '../file_manager/mixins/imageGallery'
export default {
  components: { Header, Directory, FileAsset, Alert, Gallery },
  mixins: [settings, selection, uploadDrag, sorting, imageGallery],
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
      gallery: null,
      currentFolder: {}
    }
  },
  created() {
    this.requestFolder()
    this.loadSettings()
    this.onDirectoryChecked()
  },
  computed: {
    requestUrl() {
      if (window.location.href.match('/archive')) {
        return `/api/v1/archive?order=${this.order}&column=${this.column}`
      } else {
        let ary = window.location.href.split("/")
        let id = [...ary].reverse()[0]
        return `/api/v1/folders/${id}?order=${this.order}&column=${this.column}`
      }
    }, 
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
    ...mapState(['order', 'column']),
    showAlert() {
      return this.files.length === 0 && this.directories.length === 0
    }
  },
  methods: {
    setLoadedData(folder) {
      this.reset()
      this.currentFolder = folder
      this.archiveRoot = folder
      folder.children.forEach(child => {
        this.directories.push(child)
      })
      folder.assets.forEach(asset => {
        this.assets.push(asset)
        if (asset.assettype === "image") {
          this.addImageToGallery(asset)
        } 
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
    requestFolder() {
      $.getJSON(this.requestUrl, (folder) => {
        this.setLoadedData(folder)
      })
    }
  }
}
</script>