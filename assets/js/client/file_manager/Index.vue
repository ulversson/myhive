<template>
	<div class='card-body' style='padding: 1rem 0 0 0'>
  <div class='nav-tabs-vertical file-manager'>
    <DecryptModal 
      :assets="encryptedAssets"  :color="textColor" 
      :currentFolder="currentFolder.id"/>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder" 
      :assets="orderedAssets"
			:showTimeline="timelineVisible && !isRootNotLoaded && isAdmin"
      :isAdmin="isAdmin" ref='headerPanel'/>
    <TabLinks 
      :textColor="textColor"
			:currentFolder="currentFolder"
      :children="alphabeticalChildren" 
			:setCurrentFolder="setCurrentFolder"/>
		<toggle-button @change="toggleTimeline"
      :font-size="9"  :class="`timeline-switch`" :width="70"
      :labels="{
				checked: 'files',
      	unchecked: 'timeline' }"
			v-if="timelineVisible && !isRootNotLoaded"/>
    <div class="tab-content">
      <div class="tab-pane"  
        style="min-height: 400px !important"
        v-cloak @drop.prevent="addFile" @dragover.prevent
        v-for="(tab, index) in alphabeticalChildren"
        :key="index"
        :class="index == 0 ? 'active': ''" 
        :id="`#f${tab.id}`">
        <FolderContent v-if="index == 0 && (isRootNotLoaded || !timelineStatusLoaded)"
          :directories="orderedDirectories"
          :assets="orderedAssets"
          ref="content"
          :filter="filter"
          :currentFolder="currentFolder">
        </FolderContent>
      </div>
      <GalleryTwo ref="gallery" :items="galleryAssets" />
    </div>
    <MainTimeline ref="timeline" 
			:timelineId="currentFolder.id" 
			:showOnInit="timelineStatusLoaded"
			:isAdmin="isAdmin" v-show="!isRootNotLoaded && timelineStatusLoaded"/>
  </div>
</div>
</template>
<script>
import sort from 'fast-sort'
import { mapState } from 'vuex'
import FolderContent from './components/FolderContent.vue'
import Header from './components/Header.vue'
import GalleryTwo from './components/manager/file_types/GalleryTwo.vue'
import DecryptModal from './components/decryption/DecryptModal.vue'
import TabLinks from './components/TabLinks.vue'
import ProgressKnob from './components/timeline/ProgressKnob.vue'
import MainTimeline from './components/timeline/MainTimeline.vue'
import settings from './mixins/settings'
import sorting from './mixins/sorting'
import shared from '../medico_legal_cases/mixins/shared'
import selection from './mixins/selection'
import uploadDrag from './mixins/upload-drag'
import imageGallery from './mixins/imageGallery'
import activeTab from '../medico_legal_cases/mixins/activeTab'
import serialization from '../time_sheet/mixins/serialization'
import globals from '../medico_legal_cases/mixins/globals'
import inboxRefresh from '../email_inbox/mixins/inboxRefresh'
export default {
  data() {
    return {
      files:[], //upload fies 
      filter: "", //search filter
      fileAssets: [], //files in directory
      folderData: {}, //root folder
      galleryAssets: [], //images in the folder
      currentFolder: {},
			currentTabId: 0,
			progress: 0,
			timelineStatusLoaded: false,
			timelineVisible: false
    }
  },
  created() {
    this.setCaseFolder(this.caseFolder)
    this.setMedicoLegalCaseId()
    this.setAccountId()
    this.loadAppModules()
		this.toggleTimeSheet()
		this.$root.$on('timeline', (timeline) => {
			this.timelineVisible = this.timelineStatusLoaded = timeline.show
			this.progress = parseInt(Math.round(timeline.sum, 0).toFixed(0))
		})
  },
  computed: {
    ...mapState(['column', 'order']),
    showTimeline() {
      return !this.isRootNotLoaded && this.timelineStatusLoaded
    },
    isRootNotLoaded() {
      return this.ancestorsIds.length > 0
    },
    alphabeticalChildren() {
      return sort(this.rootChildren).asc(c => c.name).filter(f => !f.name.match('_'))
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
      return this.currentFolder.ancestors.map(child => {
        return child.id
      })
    },
    currentFolderChildren() {
      if (this.currentFolder.children) {
        return this.currentFolder.children.filter(d => !d.name.startsWith("_"))
      } else {
        return []
      }
    },
    encryptedAssets() {
      return this.fileAssets.filter(fa => fa.encrypted)
    }
  },
  methods: {
		toggleTimeline() {
			this.timelineStatusLoaded = !this.timelineStatusLoaded
		},
    toggleTimeSheet() {
      let isInFileManager = window.location.pathname === "/folders"
      let caseId = this.$store.state.currentMedicoLegalCaseId
      if (isInFileManager && caseId) {
        $(".cui-topbar-menu-button.cui-menu-right-action-toggle").show()
				$("div.time-sheet-toggle").show()
				$("div.email-toggle").show()
        $('div.mlc-details-toggle').show()
      } else {
        $(".cui-topbar-menu-button.cui-menu-right-action-toggle").hide()
				$("div.time-sheet-toggle").hide()
				$("div.email-toggle").hide()
        $('div.mlc-details-toggle').hide()
      }
    },
    loadAppModules() {
      this.$store.dispatch('loadAppModules', 
        localStorage.getItem('currentAccount')).then((modules) => {
          this.$store.commit('setAppModules', modules)
        })
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
    reset() {
      $("input:checked").click()
      this.fileAssets.splice(0, this.fileAssets.length)
      this.filter = ''
      this.galleryAssets.splice(0, this.galleryAssets.length)
    },
    setCaseFolder(folderId) {
      this.reset()
      this.$store.dispatch('setCaseFolder', {
        caseFolder: folderId
      }).then((folderData) => {
        this.folderData = folderData
        let firstItem = this.folderData.children[0].id
        this.setCurrentFolder(folderData.id)
        this.setHeader()
        this.setCurrentTab(folderId)
        this.$store.commit('setRole', folderData.roles[0])
        this.loadSettings().then((res) => {
          this.$store.commit("setColumn", res.settings.default_file_sort_column)
          this.$store.commit("setOrder", res.settings.default_file_sort_order)
          this.$store.commit('setOAuth2', {microsoft: res.microsoft})
				})
      }).catch((err) => {
        this.showGenericError()
      })
    },
    setCurrentFolder(folderId, decrypt = false) {
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
          if (decrypt && this.encryptedAssets.length > 0) {
            this.showDecryptionPrompt()
          }
        })
      }).catch((err) => {
        console.error(err)
        //this.showGenericError()
      })
    },
    showDecryptionPrompt() {
      this.$swal({
        title: 'Encrypted files',
        text: "Some files from this directory are encrypted. Would you like to strip their passwords?",
        icon: 'question',
        showCancelButton: true,
        cancelButtonText: "No",
        confirmButtonText: 'Yes, please!'
      }).then((result) => {
        if (result.value) {
          this.$modal.show('decrypt-modal')
        }
      })
    },
    setHeader() {
      if (this.folderData) {
        $('strong.case-header').html(this.folderData.name)
      }
      let status = window.localStorage.getItem('caseStatus')
      let color = `text-${this.textClassFromStatus(status)}`
      let reference = window.localStorage.getItem('caseRef')
      $("small.text-muted.ref").html(reference)
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
    FolderContent, Header, GalleryTwo, DecryptModal,
    MainTimeline, TabLinks, ProgressKnob
  },
  mixins: [
    settings, 
    selection, 
    shared, 
    activeTab, 
    serialization,
    uploadDrag,
    sorting,
    globals,
		imageGallery,
		inboxRefresh
  ]
}
</script>