<template>
  <div class='nav-tabs-vertical'>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder" 
    ref='headerPanel'/>
    <ul class="nav nav-tabs" role="tablist" id='folder-tabs'>
      <li class="nav-item" :key='index'
        v-for="(tab, index) in rootChildren">
          <a class="nav-link" 
            :class="showTab(tab) ? 'active': ''"
            href="javascript:void(0)" 
            @click="setCurrentFolder(tab.id); setCurrentTab(tab.id)"
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
        :class="showTab(tab) ? 'active': ''" 
        :id="`#f${tab.id}`">
        <folder-content v-if="showTab(tab)"
          :directories.sync="filteredDirectories"
          :assets="filteredAssets"
          ref="content"
          :filter="filter"
          :currentFolder="currentFolder">
        </folder-content>
      </div>
      <Gallery ref="gallery" :items="galleryAssets" />
    </div>
  </div>
</template>
<script>
import FolderContent from './components/FolderContent.vue'
import Header from './components/Header.vue'
import Gallery from './components/manager/file_types/Gallery.vue'
export default {
  data() {
    return {
      files:[], //upload fies 
      filter: "", //search filter
      fileAssets: [], //files in directory
      folderData: {}, //root folder
      galleryAssets: [], //images in the folder
      currentFolder: {},
      currentTabId: 0
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
    ancestorsIds() {
      if (!this.currentFolder.ancestors) return []
      return this.currentFolder.ancestors.map(child =>{
        return child.id
      })
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
    setCurrentTab(id) {
      this.currentTabId = id
    },
    showTab(tab) {
      return tab.id === this.currentTabId || this.ancestorsIds.includes(tab.id)
    },
    addImageToGallery(asset) {
      this.galleryAssets.push({
        id: asset.id,
        src: asset.link,
        w: asset.metadata.width,
        h: asset.metadata.height,
        pid: `image-${asset.id}`
      })
    },
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
      let droppedFiles = e.dataTransfer.files
      if(!droppedFiles) return
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
        this.setCurrentTab(firstItem)
        this.$store.commit('setRole', folderData.roles[0])
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
            this.addImageToGallery(asset)
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
    FolderContent, Header, Gallery
  }
}
</script>