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
          :directories.sync="currentFolderChildren"
          :assets="fileAssets"
          ref="content"
          :currentFolder="currentFolder" />
        <alert v-if="showEmptyAlert" 
          message="This folder is currently empty"/>
      </div>
    </div>
  </div>
</template>
<script>
import FolderContent from './components/FolderContent.vue'
import Header from './components/Header.vue'
import Alert from './components/Alert.vue'
export default {
  data() {
    return {
      files:[],
      fileAssets: [],
      folderData: {},
      currentFolder: {}
    }
  },
  created() {
    this.setCaseFolder(this.caseFolder)
    this.$on('checked.folder', (data) => {
      if (data.checked) {
        this.$refs.headerPanel.selectedItems.push(data)
      } else {
        let element = this.$refs.headerPanel.selectedItems.find(i => i.id === data.id && i.type === data.type)
        let idx = this.$refs.headerPanel.selectedItems.indexOf(element)
        this.$delete(this.$refs.headerPanel.selectedItems, idx)
      }
    })
    this.$on('checked.asset', (data) => {
      if (data.checked) {
        this.$refs.headerPanel.selectedItems.push(data)
      } else {
        let element = this.$refs.headerPanel.selectedItems.find(i => i.id === data.id && i.type === data.type)
        let idx = this.$refs.headerPanel.selectedItems.indexOf(element)
        this.$delete(this.$refs.headerPanel.selectedItems, idx)
      }
    })
  },
  computed: {
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
    clearAssets() {
      this.fileAssets.splice(0, this.fileAssets.length)

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
      this.clearAssets()
      this.$store.dispatch('setCurrentFolder', {
        currentFolder: folderId
      }).then((folderData) => {
        this.currentFolder = folderData
        this.currentFolder.assets.forEach(asset => {
          this.fileAssets.push(asset)
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
    FolderContent, Header, Alert
  }
}
</script>