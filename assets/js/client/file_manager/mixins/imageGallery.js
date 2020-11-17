export default {
  methods: {
    addImageToGallery(asset) {
      this.galleryAssets.push({
        id: asset.id,
        src: asset.link,
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