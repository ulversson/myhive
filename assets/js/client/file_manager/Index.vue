<template>
  <div class='nav-tabs-vertical'>
    <Header />
    <ul class="nav nav-tabs" role="tablist" id='folder-tabs'>
      <li class="nav-item" :key='index'
        v-for="(tab, index) in folderData.children">
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
        v-for="(tab, index) in rootChildren"
        :key="index"
        :class="index == 0 ? 'active' : ''" 
        :id="`#f${tab.id}`">
        <folder-content v-if="currentFolder" :directories.sync="currentFolderChildren"/>
        <alert v-if="currentFolderChildren.length === 0" 
          message="This folder is currently empty"/>
      </div>
    </div>
  </div>
</template>
<script>
import FolderContent from './FolderContent.vue'
import Header from './Header.vue'
import Alert from './components/Alert.vue'
export default {
  data() {
    return {
      folderData: null,
      currentFolder: null
    }
  },
  created() {
    this.setCaseColder(this.caseFolder)
  },
  computed: {
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
    setCaseColder(folderId) {
      this.$store.dispatch('setCaseFolder', {
        caseFolder: folderId
      }).then((folderData) => {
        this.folderData = folderData
        let firstItem = this.folderData.children[0].id
        this.setCurrentFolder(firstItem)
      })
    },
    setCurrentFolder(folderId) {
      this.$store.dispatch('setCurrentFolder', {
        currentFolder: folderId
      }).then((folderData) => {
        this.currentFolder = folderData
      })
    }
  },
  components: {
    FolderContent, Header, Alert
  }
}
</script>