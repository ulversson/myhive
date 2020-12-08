<template>
 <div class='photo-id'>
    <croppa v-model="photoId" 
      :height="initialH"
      :width="initialW"
      :show-loading="true"
      :initial-image="consultation.photo_id"
      :remove-button-size="30"
      @new-image-drawn="onNewImage"
      class='photo-id'
      @zoom="onZoom">
    </croppa>
    <input type="range" @input="onSliderChange" 
      :min="sliderMin" :max="sliderMax" 
      step=".001" v-model="sliderVal"> 
      {{sliderVal.toFixed(2)}}
        <div class='buttons'>
          <button class="btn btn-sm btn-primary pull-left mt-2 mr-2"
            style="float: left; margin-bottom: 20px !important;"
            @click="save()">
            <i class="fas fa-save"></i>&nbsp;Save
          </button>
          <a class="btn btn-sm btn-secondary pull-left mt-2 mr-2"
            style="float: left; margin-left: 0px !important;margin-bottom: 20px !important;"
            @click="hideWindow()">
            <i class="far fa-times-circle"></i>&nbsp;Reset
          </a>
      </div>
  </div>
</template>
<script>
export default {
  props: ['consultation'],
  data() {
     return {
      photoId: null,
      initialImage: "",
      sliderVal: 0,
      sliderMin: 0,
      sliderMax: 0,
      initialH: 300,
      initialW: 600
     }
   },
   methods: {
    save() {
      let fileData = this.photoId.generateDataUrl()
      let vm = this
      $.ajax({
        url: `/api/v1/patient_consultation/photo_id`,
        type: 'POST',
        data: {
          photo_id: {
            image: fileData,
            consultation_id: vm.consultation.id
          }
        }
      })
    },      
    onNewImage() {
      this.sliderVal = this.photoId.scaleRatio
      this.sliderMin = this.photoId.scaleRatio / 2
      this.sliderMax = this.photoId.scaleRatio * 2
    },  
    onSliderChange(evt) {
      var increment = evt.target.value
      this.photoId.scaleRatio = +increment
    },
    onZoom() {
      if (this.sliderMax && this.photoId.scaleRatio >= this.sliderMax) {
       this.photoId.scaleRatio = this.sliderMax
      } else if (this.sliderMin && this.photoId.scaleRatio <= this.sliderMin) {
         this.photoId.scaleRatio = this.sliderMin
      }
      this.sliderVal = this.photoId.scaleRatio
    }
   }
}
</script>
<style>
input[type=range]{
  width: 600px;
}
</style>