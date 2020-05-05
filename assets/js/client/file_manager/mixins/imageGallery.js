export default {
  computed: {
    gallery() {
      return this.managerComponent.$refs.gallery
    },
    galleryAssets() {
      return this.managerComponent.galleryAssets
    },
    currentGalleryItem() {
      return this.galleryAssets.filter(i => {
        return i.id === this.fileAsset.id
      })[0]
    },
    currentGalleryItemIdx() {
      return this.galleryAssets.indexOf(this.currentGalleryItem)
    }
  }
}