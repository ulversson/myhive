<template>
  <tr class='asset'>
    <td style='max-width: 40px; width: 40px' data-type="fileAsset" :data-id="fileAsset.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" @click="emitAssetChecked($event, fileAsset.id, 'asset')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon text-secondary" 
      @click="openFile()">
      <i :class="fileAsset.icon"></i>
    </td>
    <td class="cui-github-explore-nav-content">
      <a href="#" class="cui-github-explore-nav-link" 
        v-html="highlight()" @click="openFile()" />
    </td>
    <td class="cui-github-explore-nav-descr text-muted">{{ fileAsset.caption}}</td>
    <td class="cui-github-explore-nav-time">{{ dateAgo }}</td>
    <FileAssetActions :fileAsset="fileAsset" :currentFolder="currentFolder" />
    <AssetModal :fileAsset.sync="fileAsset" :showModal.sync="showModal"  
      v-if="isModalAsset"/>
  </tr>
</template>
<script>
import FileAssetActions from '../actions/FileAssetActions.vue'
import currentFolder from '../../mixins/currentFolder'
import imageGallery from '../../mixins/imageGallery'
import AssetModal from '../manager/file_types/AssetModal.vue'

export default {
  props: ['fileAsset', 'highlightFilter', 'currentFolder'],
  mixins: [currentFolder, imageGallery],
  components: { FileAssetActions, AssetModal },
  data() {
    return {
      galleryItems: [],
      showModal: false, 
      viewCount: this.fileAsset.view_counts
    }
  },
  methods: {
    emitAssetChecked(evt, elementId, elemetType) {
      let isChecked = $(evt.target).prop('checked')
      this.managerComponent.$emit('checked.folder', {
        checked: isChecked,
        type: elemetType,
        id: elementId
      })
    },
    highlight() {
      if(this.highlightFilter === "") {
        return this.assetName
      }
      return this.fileAsset.name.replace(new RegExp(this.highlightFilter, "gi"), match => {
        return '<span class="highlightText">' + match + '</span>'
      })  
    },
    hideNewLabel(){
      this.viewCount = this.viewCount + 1
    },
    openFile() {
      this.hideNewLabel()
      switch(this.fileAsset.assettype) {
        case "video":
          this.$modal.show(this.modalId)
        break
        case "download":
          window.open(this.fileAsset.link, "_blank")
        break
        case "view":
          window.open(this.fileAsset.link, "_blank")
        break
        case "image":
          if (this.gallery) {
            this.gallery.index = this.currentGalleryItemIdx
            this.gallery.init(this.galleryAssets)
          }
        break
      }
    }
  },
  computed: {
    assetName() {
      if (this.showNewLabel) {
        return `${this.fileAsset.name}&nbsp;<span class='badge badge-danger'>new</span>`
      } else {
        return this.fileAsset.name
      }
    },
    modalId() {
      return 'asset-modal-' + this.fileAsset.id
    },
    dateAgo() {
      return moment(this.fileAsset.updated_at).fromNow()
    },
    showNewLabel() {
      return this.viewCount == 0
    },
    isModalAsset() {
      return this.fileAsset.assettype === "video"
    }
  }
}
</script>