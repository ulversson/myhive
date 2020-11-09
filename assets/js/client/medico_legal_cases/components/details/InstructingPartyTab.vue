<template>
  <div class="card" style='margin-bottom: 0'>
    <div class="card-body">
      <h5 class="mb-3 text-default">
        <strong>
          <i class='fa fa-2x icmn-office'></i>
          &nbsp;{{this.medicoLegalCase.instructing_party.name}}
        </strong>   
      </h5>
      <dl class="row"
        v-if="this.medicoLegalCase.instructing_party.reference != null">
        <dt class="col-xl-4">Reference</dt>
        <dd class="col-xl-8">
          <i class="fas fa-address-book"></i>&nbsp;
          {{ this.medicoLegalCase.instructing_party.reference }}
        </dd>
      </dl>  
      <common-address :medicoLegalCase='medicoLegalCase' :entity="'instructing_party'"/> 
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