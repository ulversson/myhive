<template>
  <div class='consultation-files'
    style="width: 100% !important">
    <div :class="`DashboardContainer-${consultation.id}`"></div>
    <Header :currentFolderId="currentFolderId" 
      :currentFolder.sync="currentFolder"
      :consultation.sync="consultation"
      :uploadButton="uploadButton"
      :disableBack="true"
      ref='headerPanel'/> 
    <table class='consultation-files cui-github-explore-nav table table-hover'
      v-cloak @drop.prevent="addFile" @dragover.prevent>
      <FileAsset :fileAsset="fileAsset" 
        ref="files"
        v-for="fileAsset in assets" 
        :highlightFilter.sync="filter"
        :currentFolder.sync="currentFolder"
        :key="fileAsset.id" />
    </table>
  </div>
</template>
<script>
import { mapState } from 'vuex'
import imageGallery from '../../../file_manager/mixins/imageGallery'
import sorting from '../../../file_manager/mixins/sorting'
import selection from '../../../file_manager/mixins/selection'
import upload from '../../../file_manager/mixins/upload'
import uploadDrag from '../../../file_manager/mixins/upload-drag'
import Header from './ConsultationFileManagerHeader.vue'
import FileAsset from '../../../file_manager/components/manager/FileAsset.vue'
export default {
  mixins: [imageGallery, sorting, selection, upload, uploadDrag],
  components: { Header, FileAsset },
  props: {
    consultation: {
      type: Number,
      default: null
    },
    rootId: {
      type: String, 
      default:  null
    },
    target: {
      type: String,
      default: null
    },
    uploadButton: {
      type: String,
      default: null
    }
  },
  created(){
    if (this.rootId) {
      this.requestFolder()
    }
  },
  data() {
    return {
      currentFolder: null,
      currentFolderId: null,
      assets: [],
      files: [],
      galleryAssets: [],
      isConsultation: true
    }
  },
  methods: {
    reset() {
      $("input:checked").click()
      this.assets.splice(0, this.assets.length)
      this.filter = ""
      this.galleryAssets.splice(0, this.galleryAssets.length)
    },
    requestFolder() {
      $.getJSON(this.requestUrl, (folder) => {
        this.setLoadedData(folder)
      })
    },
    setLoadedData(folder) {
      this.reset()
      this.currentFolder = folder
      this.currentFolderId = folder.id
      folder.assets.forEach(asset => {
        this.assets.push(asset)
        if (asset.assettype === "image") {
          this.addImageToGallery(asset)
        } 
      })
    },
    loadConsultation(id){
      $.ajax({
        url: `/api/v1/consultation/${id}`,
        type: 'GET',
        contentType: 'application/json'
      }).done((consultation) => {
        this.consultation = consultation
      })
    }
  },
  computed: {
    ...mapState(['order', 'column']),
    requestUrl() {
      debugger
      return  `/api/v1/folders/${this.rootId}?order=${this.order}&column=${this.column}`
    }
  }
}
</script>