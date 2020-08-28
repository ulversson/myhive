<template>
  <div class='pdf-items'>
    <a class="dropdown-item" 
      v-if="asset.encrypted"
      @click="showDecryption()">
      <i class="fas fa-unlock"></i>
      &nbsp;Decrypt
    </a>
  </div>
</template>
<script>
import DecryptModal from '../../decryption/DecryptModal.vue'
export default {
  components: { DecryptModal },
  props: ['asset'],
  methods: {
    showDecryption(){
      this.$modal.show('decrypt-modal')
    }
  }
}
</script>