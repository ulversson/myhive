<template>
  <div class='radiology-modality' style='font-size: 16px'>
    <a class='badge badge-pill text-white'
      :style="`background-color: ${modality.color} !important`">
      {{$attrs.data['Modalities in Study']}}
    </a>
  </div>
</template>
<script>
import modalities from '../modalities'
export default {
  props: ['row'],
  mounted() {
  },
  computed: {
    modality() {
      const modalitiesShort = Object.keys(this.modalities)
      const modalityName = modalitiesShort.filter(m => m == this.$attrs.data["Modalities in Study"].trim())
      console.log(modalityName)
      return this.modalities[modalityName]
    }
  },
  data() {
    return {
      modalities: modalities
    }
  }
}
</script>