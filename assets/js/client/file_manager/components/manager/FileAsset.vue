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
  </tr>
</template>
<script>
import FileAssetActions from '../actions/FileAssetActions.vue'
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['fileAsset', 'highlightFilter', 'currentFolder'],
  mixins: [currentFolder],
  components: { FileAssetActions },
  data() {
    return {
      galleryItems: []
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
    openFile() {
      switch(this.fileAsset.assettype) {
        case "modal":
        break
        case "download":
          window.open(this.fileAsset.link, "_blank")
        break
        case "view":
          window.open(this.fileAsset.link, "_blank")
        break
        case "image":
          let photoGallery = this.managerComponent.$refs.gallery
          if (photoGallery) {
            let items = this.managerComponent.galleryAssets
            let item = items.filter(i => {
              return i.id === this.fileAsset.id
            })[0]
            let index = items.indexOf(item)
            photoGallery.index = index
            photoGallery.init(items)
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
        this.fileAsset.name
      }
    },
    dateAgo() {
      return moment(this.fileAsset.updated_at).fromNow()
    },
    showNewLabel() {
      return this.fileAsset.view_counts.length === 0
    }
  }
}
</script>