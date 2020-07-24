<template>
  <div class='nav-tabs-vertical'>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder" 
      ref='headerPanel'/>
    <ul class="nav nav-tabs" role="tablist" id='folder-tabs'>
      <li class="nav-item" :key='index'
        v-for="(tab, index) in alphabeticalChildren">
          <a class="nav-link" 
            :class="showTab(tab) ? 'active': ''"
            href="javascript:void(0)" 
            @click="setCurrentFolder(tab.id); setCurrentTab(tab.id)"
            data-toggle="tab" role="tab"
            :data-target="`#f${tab.id}`">
          <i :class="folderIcon(tab)"
            :style='`color: ${textColor} !important`'></i>
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
import sort from 'fast-sort'
import FolderContent from './components/FolderContent.vue'
import Header from './components/Header.vue'
import Gallery from './components/manager/file_types/Gallery.vue'
import AnswerCall from '../chat/components/video/AnswerCall.vue'
import settings from './mixins/settings'
import shared from '../medico_legal_cases/mixins/shared'
import currentFolder from './mixins/currentFolder'
import selection from './mixins/selection'
import uploadDrag from './mixins/upload-drag'
import activeTab from '../medico_legal_cases/mixins/activeTab'
import serialization from '../time_sheet/mixins/serialization'
import globals from '../medico_legal_cases/mixins/globals'
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
    this.setMedicoLegalCaseId()
    this.setAccountId()
    this.loadAppModules()
    this.toggleTimeSheet()
  },
  computed: {
    alphabeticalChildren() {
      return sort(this.rootChildren).asc(c => c.name)
    },
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
      return window.localStorage.getItem('caseFolder')
    },
    rootChildren() {
      if (this.folderData.children) {
        if (this.isAdmin) {
          return this.folderData.children
        } else {
          return this.folderData
                     .children
                     .filter(child => child.folder_type !== "medico_legal_case_admin")
        }
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
    toggleTimeSheet() {
      let isInFileManager = window.location.pathname === "/folders"
      let caseId = this.$store.state.currentMedicoLegalCaseId
      if (isInFileManager && caseId) {
        $(".cui-topbar-menu-button.cui-menu-right-action-toggle").show()
      } else {
        $(".cui-topbar-menu-button.cui-menu-right-action-toggle").hide()
      }
    },
    loadAppModules() {
      this.$store.dispatch('loadAppModules', 
        localStorage.getItem('currentAccount')).then((modules) => {
          this.$store.commit('setAppModules', modules)
        })
    },
    folderIcon(tab) {
      if (tab.folder_type === 'medico_legal_case') {
        if (this.currentFolder.id === tab.id) 
            return  'fas fa-folder-open' 
          else 
            return 'fas fa-folder'
      } else {
        return tab.icon
      }
    },
    setCurrentTab(id) {
      this.currentTabId = id
    },
    setMedicoLegalCaseId() {
      this.$store.commit('setMedicoLegalCaseId', 
        parseInt(localStorage.getItem('currentMedicoLegalCaseId')))
    },
    setAccountId() {
      this.$store.commit('setAccountId', 
        parseInt(localStorage.getItem('currentAccount')))
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
    reset() {
      $("input:checked").click()
      this.fileAssets.splice(0, this.fileAssets.length)
      this.filter = ""
      this.galleryAssets.splice(0, this.galleryAssets.length)
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
        this.loadSettings().then((res) => {
          this.$store.commit("setColumn", res.settings.default_file_sort_column)
          this.$store.commit("setOrder", res.settings.default_file_sort_order)
        })
      }).catch((err) => {
        this.showGenericError()
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
      }).catch((err) => {
        this.showGenericError()
      })
    },
    setHeader() {
      if (this.folderData) {
        $('strong.case-header').html(this.folderData.name)
      }
      let status = window.localStorage.getItem('caseStatus')
      let color = `text-${this.textClassFromStatus(status)}`
      $("i#case-folder").addClass(color)
      $("[data-case-id]").html(this.folderData.name)
      if (this.isFormSerialized()) {
        $("div.red.circle").show()
      } else {
        $("div.red.circle").hide()
      }
    },  
    showGenericError(){
      this.$swal("Unauthorized", 
        "You are not authorized to perform this action!. You will be redirected", 
        "error")
      setTimeout(() => {
        window.location.href = "/"
      }, 2500)
    },
    textClassFromStatus(status) {
      switch(status) {
        case 'pending':
          return 'warning'
        case 'current':
          return 'success'
        case 'settled':
          return 'secondary'
      }
    }
  },
  components: {
    FolderContent, Header, Gallery
  },
  mixins: [
    settings, 
    selection, 
    shared, 
    activeTab, 
    serialization,
    uploadDrag,
    globals
  ]
}
</script>