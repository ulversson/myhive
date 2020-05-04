<template>
  <div class='nav-tabs-vertical'>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder" 
    ref='headerPanel'/>
    <ul class="nav nav-tabs" role="tablist" id='folder-tabs'>
      <li class="nav-item" :key='index'
        v-for="(tab, index) in rootChildren">
          <a class="nav-link" 
            :class="index == 0 ? 'active' : ''"
            href="javascript:void(0)" 
            @click="setCurrentFolder(tab.id)"
            data-toggle="tab" role="tab"
            :data-target="`#f${tab.id}`">
          <i :class="currentFolder.id === tab.id ? 'icmn-folder-open' : 'icmn-folder'"></i>
          &nbsp;{{tab.name}}
        </a>
      </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane"  
        style="min-height: 400px !important"
        v-cloak @drop.prevent="addFile" @dragover.prevent
        v-for="(tab, index) in rootChildren"
        :key="index"
        :class="index == 0 ? 'active' : ''" 
        :id="`#f${tab.id}`">
        <folder-content v-if="currentFolder" 
          :directories.sync="filteredDirectories"
          :assets="filteredAssets"
          ref="content"
          :filter="filter"
          :currentFolder="currentFolder" />
        <alert v-if="showEmptyAlert" 
          message="This folder is currently empty"/>
      </div>
      <Gallery ref="gallery" :items="galleryAssets" />
    </div>
  </div>
</template>
<script>
import FolderContent from './components/FolderContent.vue'
import Header from './components/Header.vue'
import Alert from './components/Alert.vue'
import Gallery from './components/manager/file_types/Gallery.vue'
export default {
  data() {
    return {
      files:[],
      filter: "",
      fileAssets: [],
      folderData: {},
      galleryAssets: [],
      currentFolder: {}
    }
  },
  created() {
    this.setCaseFolder(this.caseFolder)
    this.$on('checked.folder', (data) => {
      if (data.checked) {
        this.addSelectedItem(data)
      } else {
        this.removeItemFromSelected(data)
      }
    })
    this.$on('checked.asset', (data) => {
      if (data.checked) {
        this.addSelectedItem(data)
      } else {
        this.removeItemFromSelected(data)
      }
    })
  },
  computed: {
    filteredAssets() {
      if (this.filter === "") return this.fileAssets
      return this.fileAssets.filter((asset) => {
        return asset.name.toLowerCase().includes(this.filter.toLowerCase())
      })
    },
    filteredDirectories() {
      if (this.filter === "") return this.currentFolderChildren
      return this.currentFolderChildren.filter((dir) => {
        return dir.name.toLowerCase().includes(this.filter.toLowerCase())
      })
    },
    showEmptyAlert() {
      return this.currentFolderChildren.length === 0 
        && this.currentFolder.assets
        && this.currentFolder.assets.length === 0
    },
    uppy() {
      return this.$refs.headerPanel.$data.uppy
    },
    caseFolder() {
      return parseInt(window.localStorage.getItem('caseFolder'))
    },
    rootChildren() {
      if (this.folderData.children) {
        return this.folderData.children
      } else {
        return []
      }
    },
    currentFolderChildren() {
        if (this.currentFolder.children) {
        return this.currentFolder.children
      } else {
        return []
      }
    }
  },
  methods: {
    addSelectedItem(data) {
      this.$store.commit('addSelectedItem', data)
    },
    removeItemFromSelected(data) {
      this.$store.commit('removeSelectedItem', data)
    },
    reset() {
      $("input:checked").click()
      this.fileAssets.splice(0, this.fileAssets.length)
      this.filter = ""
      this.galleryAssets.splice(0, this.galleryAssets.length)
      //this.$refs.headerPanel.$refs.rightPanel.$refs.search.search = ""
    },
    addFile(e) {
      let droppedFiles = e.dataTransfer.files;
      if(!droppedFiles) return;
      ([...droppedFiles]).forEach(f => {
        this.files.push(f)
        let reader = new FileReader()
        this.uppy.addFile({
          name: f.name,
          type: f.type,
          data: f
        })
        $("button.upload-button").click()
      })
    },
    setCaseFolder(folderId) {
      this.reset()
      this.$store.dispatch('setCaseFolder', {
        caseFolder: folderId
      }).then((folderData) => {
        this.folderData = folderData
        let firstItem = this.folderData.children[0].id
        this.setCurrentFolder(firstItem)
        this.setHeader()
      })
    },
    setCurrentFolder(folderId) {
      this.reset()
      this.$store.dispatch('setCurrentFolder', {
        currentFolder: folderId
      }).then((folderData) => {
        this.currentFolder = folderData
        this.currentFolder.assets.forEach(asset => {
          this.fileAssets.push(asset)
          if (asset.assettype === "image") {
            this.galleryAssets.push({
              id: asset.id,
              src: asset.link,
              w: asset.metadata.width,
              h: asset.metadata.height
            })
          }
        })
      })
    },
    setHeader() {
      if (this.folderData) {
        $('strong.case-header').html(this.folderData.name)
      }
    }
  },
  components: {
    FolderContent, Header, Alert, Gallery
  }
}
</script>