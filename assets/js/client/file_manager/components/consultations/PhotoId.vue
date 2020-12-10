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
      v-if="showCroppa"
      @zoom="onZoom">
    </croppa>
    <img :src="photoUrl" 
      :style="`width: ${initialW}px; height: ${initialH}px;`" 
      v-if="showCroppa === false" />
    <input type="range" @input="onSliderChange" 
      :min="sliderMin" :max="sliderMax" 
      step=".001" v-model="sliderVal"
      v-if="showCroppa" > 
      <span v-if="showCroppa">{{sliderVal.toFixed(2)}}</span>
        <div class='buttons'>
          <button class="btn btn-sm btn-primary pull-left mt-2 mr-2"
            style="float: left; margin-bottom: 20px !important;"
            @click="save()"
            v-if="showCroppa">
            <i class="fas fa-save"></i>&nbsp;Save Photo ID
          </button>
          <button class="btn btn-sm btn-warning pull-left mt-2 mr-2"
            style="float: left; margin-bottom: 20px !important;"
            @click="edit()"
            v-if="!showCroppa">
            <i class="fas fa-edit"></i>&nbsp;Change Photo ID
          </button>
          <button class="btn btn-sm btn-secondary pull-left mt-2 mr-2"
            style="float: left; margin-bottom: 20px !important;"
            @click="cancel()"
            v-if="showCroppa">
            <i class="fas fa-ban"></i>&nbsp;Cancel
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
      initialW: 600,
      isEditing: false
     }
   },
   computed: {
     showCroppa() {
       return this.photoUrl === '' || this.isEditing === true
    },
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
    cancel() {
      this.isEditing = false
    },
    edit() {
      this.isEditing = true
    },
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
      }).done((consultation) => {
        vm.photoDatabaseId = consultation.photo_id.id
        vm.consultation = consultation
        this.isEditing = false
        this.refreshFileManager()
      }).fail((err) => {
        vm.photoDatabaseId = null
      })
    },      
    refreshFileManager() {
      this.$parent.$refs.fileManager.requestFolder()
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
        this.refreshFileManager()
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