<template>
  <div class="row col-9">
    <div>
      <LightBox
        ref="lightbox"
        :media="items"
        :show-thumbs="true"
        :show-caption="true"
        :show-light-box="false"
        :site-loading="'/images/siteloading.gif'"
      />
    </div>
  </div>
</template>

<script>
require('vue-image-lightbox/dist/vue-image-lightbox.min.css')
import LightBox from 'vue-image-lightbox'
export default {
  props: ['items'],
  components: {
    LightBox,
  },
  methods: {
    openGallery(index) {
      this.$refs.lightbox.showImage(index)
    }
  }
}
</script>