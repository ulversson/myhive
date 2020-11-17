<template>
  <div class="row col-9">
    <div>
      <ul>
        <li
          v-for="(image, index) in items"
          :key="index"
          style="display: inline-block">
          <img
            v-lazy="image.src || image.thumb"
            style="height: 100px;"
            @click="openGallery(index)">
        </li>
      </ul>
      <LightBox
        ref="lightbox"
        :media="items"
        :show-caption="true"
        :show-light-box="false"
      />
    </div>
  </div>
</template>

<script>
require('vue-image-lightbox/dist/vue-image-lightbox.min.css')
import LightBox from 'vue-image-lightbox'
export default {
  props: ['items'],
  created() {
    console.log(this.items)
  },
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