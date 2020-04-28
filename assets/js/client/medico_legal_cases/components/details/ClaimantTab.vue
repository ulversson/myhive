<template>
  <div class="card" style='margin-bottom: 0'>
    <div class="card-body">
      <h5 class="mb-3 text-default">
        <strong>
          <i class='fa fa-2x icmn-user-tie'></i>
          &nbsp;{{this.claimantName}}
        </strong>   
      </h5>
      <common-address :medicoLegalCase='medicoLegalCase' 
        :entity="'claimant'"/> 
    </div>
  </div>
</template>
<script>
import shared from '../../mixins/shared'
import globals from '../../mixins/globals'
import CommonAddress from './CommonAddress.vue'
export default {
  mixins: [shared, globals],
  props: ['medicoLegalCase'],
  components: {
    CommonAddress
  }
}
</script>