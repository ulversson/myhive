<template>
 <div class='photo-id'>
    <croppa v-model="photoId" 
      :height="initialH"
      :width="initialW"
      :show-loading="true"
      :initial-image="photoUrl"
      :remove-button-size="30"
      @image-remove="onImageRemove"
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
            <i class="fas fa-save"></i>&nbsp;Save Photo ID
          </button>
      </div>
  </div>
</template>
<script>
export default {
  props: ['consultation'],
  created() {
    this.photoDatabaseId = this.obtainedDatabaseId
  },
  data() {
     return {
      photoId: null,
      photoDatabaseId: null,
      sliderVal: 0,
      sliderMin: 0,
      sliderMax: 0,
      initialH: 300,
      initialW: 600
     }
   },
   computed: {
     photoUrl() {
       if (Object.keys(this.consultation.photo_id).length > 0) {
         return this.consultation.photo_id.url
       } else {
         return ''
       }
     },
     obtainedDatabaseId() {
       if (Object.keys(this.consultation.photo_id).length > 0) {
         return this.consultation.photo_id.id
       } else {
         return null
       }
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
      }).done((jsonRes) => {
        vm.photoDatabaseId = jsonRes.id
      }).fail((err) => {
        vm.photoDatabaseId = null
      })
    },      
    onImageRemove() {
      let vm = this
      $.ajax({
        url: `/api/v1/patient_consultation/photo_id/${vm.photoDatabaseId}`,
        type: 'DELETE',
        data: {
          id: vm.photoDatabaseId
        }
      }).done((jsonRes) => {
        vm.photoDatabaseId = null
      }).fail((err) => {
        this.$swal(
          'Error', 'Unable to remove this image', 'error'
        )
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