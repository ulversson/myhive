import sort from 'fast-sort'
export default {
  methods: {
    addImageToGallery(asset) {
      this.galleryAssets.push({
        id: asset.id,
        src: asset.link,
        sources: {
          thumb: asset.link,
          src: asset.link
        },
        width: asset.metadata.width,
        height: asset.metadata.height,
        caption: asset.name,
        thumb: asset.link
      })
    }
  },
  computed: {
    lightbox() {
      return this.managerComponent.$refs.gallery.$refs.lightbox
    },
    gallery() {
      return this.managerComponent.$refs.gallery
    },
    galleryAssetsFiles() {
      return sort(this.managerComponent.galleryAssets).asc(i => i.caption)
    },
    currentGalleryItem() {
      return this.galleryAssetsFiles.filter(i => {
        return i.id === this.fileAsset.id
      })[0]
    },
    currentGalleryItemIdx() {
      return this.galleryAssetsFiles.indexOf(this.currentGalleryItem)
    }
  }
}