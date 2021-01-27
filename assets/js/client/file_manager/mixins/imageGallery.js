import sort from 'fast-sort'
const naturalSort = sort.createNewInstance({
    comparer: new Intl.Collator(undefined, { numeric: true, sensitivity: 'base' }).compare,
})

export default {
    methods: {
        addImageToGallery(asset) {
            this.galleryAssets.push({
                id: asset.id,
                path: asset.link,
                sources: [{
                    thumb: asset.link,
                    src: asset.link
                }],
                type: 'image',
                width: asset.metadata.width,
                height: asset.metadata.height,
                caption: asset.name,
                thumb: asset.link
            })
        }
    },
    computed: {
        lightbox() {
            if (this.isConsultation) {
                return this.gallery.$refs.lightbox
            } else {
                return this.managerComponent.$refs.gallery.$refs.lightbox
            }
        },
        gallery() {
            if (this.isConsultation) {
                return this.$parent.$refs.gallery
            } else {
                return this.managerComponent.$refs.gallery
            }
        },
        galleryAssetsFiles() {
            if (this.isConsultation) {
                return naturalSort(this.$parent.galleryAssets).asc(i => i.caption)
            } else {
                return naturalSort(this.managerComponent.galleryAssets).asc(i => i.caption)
            }
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