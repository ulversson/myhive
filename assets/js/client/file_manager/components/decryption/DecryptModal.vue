<template>
  <modal 
    name="decrypt-modal"
    :min-width="200" :min-height="450"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    width="35%"  height="auto">
    <div class='card'>
      <div class='card-header'>
        <h4>Encrypted files</h4>
      </div>
      <div class='card-body'>
        <form id='encrypted-items'
          v-for="asset in assets" :key="asset.id">
          <encrypted-file-item :asset="asset"
            :ref="asset.id" 
            :color="color"/>
        </form>
        <div class='buttons' style='float: right'>
          <a class='btn btn-sm btn-primary pull-right mt-2'
            @click="decrypt()">
            <i class="fas fa-lock-open"></i>&nbsp;Decrypt
          </a>
          <a class='btn btn-sm btn-secondary pull-right mt-2'
            @click="hideModal()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
        </div>
      </div>
    </div>
  </modal>
</template>
<script>
import EncryptedFileItem from './EncryptedFileItem.vue'
export default {
  components: { EncryptedFileItem },
  props: ['assets', 'color', 'currentFolder'],
  methods: {
     encryptionData() {
      let data = {}
      for (const [key, value] of Object.entries(this.$refs)) {
        if (value.length > 0) {
          data[key] = value[0].$data.password
        }
      }
      return data
    },
    hideModal() {
      this.$modal.hide('decrypt-modal')
    },
    decrypt() {
      $.post(`/api/v1/file_assets/decrypt`, {
          "assets": this.encryptionData(),
        }, (res) => {
          this.hideModal()
          this.$parent.setCurrentFolder(this.currentFolder)
      })
    }
  }
}
</script>