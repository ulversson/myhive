<template>
  <tr class='asset'>
    <td style='max-width: 40px; width: 40px' data-type="fileAsset" :data-id="fileAsset.id">
      <label class="cui-utils-control cui-utils-control-checkbox">
        <input type="checkbox" @click="emitAssetChecked($event, fileAsset.id, 'asset')">
        <span class="cui-utils-control-indicator"></span>
      </label>
    </td>
    <td class="cui-github-explore-nav-icon" 
      :style="`color: ${this.textColor} !important`"
      @click="openFile()">
      <i :class="fileAsset.icon"></i>
    </td>
    <td class="cui-github-explore-nav-content">
      <a href="#" class="cui-github-explore-nav-link" 
        v-html="highlight()" @click="openFile()" />
      <i class='fas fa-lock' v-if="fileAsset.encrypted"
        :style="`color: ${this.textColor} !important`"></i>
    </td>
    <td class="cui-github-explore-nav-descr text-muted">{{ fileAsset.caption}}</td>
    <td class="cui-github-explore-nav-time">{{ dateAgo }}</td>
    <Move :asset="fileAsset" :currentFolder="currentFolder"/>
    <FileAssetActions :fileAsset="fileAsset" :currentFolder="currentFolder" />
    <ChangeTimeStamp 
      :item="fileAsset" itemType="file" 
      :startDate="timestampDate" />
    <AssetModal :fileAsset.sync="fileAsset" :showModal.sync="showModal"  
      v-if="isModalAsset"/>
  </tr>
</template>
<script>
import FileAssetActions from '../actions/FileAssetActions.vue'
import currentFolder from '../../mixins/currentFolder'
import imageGallery from '../../mixins/imageGallery'
import settings from '../../mixins/settings'
import AssetModal from '../manager/file_types/AssetModal.vue'
import Move from '../actions/Move.vue'
import ChangeTimeStamp from '../actions/ChangeTimestamp.vue'
export default {
  props: ['fileAsset', 'highlightFilter', 'currentFolder', 'isConsultation'],
  mixins: [currentFolder, imageGallery, settings],
  components: { FileAssetActions, AssetModal, Move, ChangeTimeStamp },
  data() {
    return {
      galleryItems: [],
      showModal: false
    }
  },
  methods: {
    changeTimeStamp(){
      this.$modal.show(`change-timestamp-${this.fileAsset.id}`)
    },
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
        return `<span class="highlightText">${match}</span>`
      })  
    },
    hideNewLabel(){
      this.viewCount = this.viewCount + 1
    },
    openFile() {
      this.hideNewLabel()
      switch(this.fileAsset.assettype) {
        case "video":
        case "audio":
        case "text":
          this.$modal.show(this.modalId)
        break
        case "pdf":
        case "other":
        case "email":
        case "document":
        case "excel":
          window.open(this.fileAsset.link, "_blank")
        break
        case "image":
          if (this.gallery) {
            this.gallery.openGallery(this.currentGalleryItemIdx)
          }
        break;
      }
    }
  },
  computed: {
    timestampDate() {
      return moment.utc(this.fileAsset.updated_at).tz('Europe/London').toISOString(); 
    },
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
      return moment.utc(this.fileAsset.updated_at)
        .tz('Europe/London')
        .format('DD/MM/YYYY HH:mm')
    },
    showNewLabel() {
      return this.viewCount == 0
    },
    isModalAsset() {
      return this.fileAsset.assettype === "video" 
        || this.fileAsset.assettype === "audio"
        || this.fileAsset.assettype === "text"
    },
    viewCount() {
      return this.fileAsset.view_counts
    }
  }
}
</script>