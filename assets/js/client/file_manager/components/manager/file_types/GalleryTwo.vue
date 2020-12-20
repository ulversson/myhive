<template>
  <div class="row col-9">
    <div>
    <VueCarousel
      ref="lightbox"
      :show="showLightbox"
      @close="showLightbox = false"
      :images="items"
      >
    </VueCarousel>
    </div>
  </div>
</template>

<script>
import VueCarousel from '../../../../vendor/VueCarousel.vue'
export default {
  props: ['items'],
  components: {
    VueCarousel
	},
	data() {
		return {
			showLightbox: false
		}
	},
  methods: {
    openGallery(index) {
			this.showLightbox = true
      this.$refs.lightbox.showImage(index)
    }
  }
}
</script>