<template>
  <div class='attachment'>
    <img :src="message.thumb" 
      v-if="isImage" :alt="message.filename" 
      @click="openImageOnNewTab"/>
    <vue-plyr v-if="isVideo">
      <video id="player" v-if="isVideo"
        playsinline controls>
        <source :src="message.link" 
          :type="message.filetype" />
      </video>
    </vue-plyr>
    <vue-plyr v-if="isAudio">
      <audio v-if="isAudio">
        <source :src="message.link" 
          :type="message.filetype"/>
      </audio>
    </vue-plyr>
    <a download v-if="isOther"
      :href="message.link" class="btn btn-sm btn-info">
      <i class="icmn-download2 fa-2x" aria-hidden="true"></i>
      &nbsp;
      <strong>{{ message.filename }}</strong>
      &nbsp;
      <i :class="`${message.icon} fa-2x`" 
        aria-hidden="true"></i>
    </a>
    <p v-if="isAudio || isImage || isVideo">
      <a download 
        :href="message.link"
        style='margin-top: 5px'
        data-toggle='tooltip'
        data-title='Download'
        class="btn btn-icon btn-info btn-xs btn-rounded mr-2 mb-2">
        <i class="icmn-download2" aria-hidden="true"></i>
      </a>
    </p>
  </div>
</template>
<script>
export default {
  data() {
    return {
      media: [{
        thumb: this.message.thumb,
        src: this.message.link,
        caption: this.message.filename
      }],
    }
  },
  props: ['message'],
  computed: {
    isImage() {
      return this.message.category === 'image'
    },
    isVideo() {
      return this.message.category === 'video'
    },
    isAudio() {
      return this.message.category === 'audio'
    },
    isOther() {
      return !this.isAudio && !this.isImage && !this.isVideo
    }
  }, 
  methods: {
    openImageOnNewTab() {
      window.open(this.message.link, "_blank")
    },
    downloadFile() {
      window.location.href=this.message.link
    }
  }
}
</script>