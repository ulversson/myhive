<template>
  <dl class='row'>
    <dt class="col-xl-4">Address</dt>
    <dd class="col-xl-8" v-if="hasAddress(this.entity)">
      <i class="fas fa-address-card text-secondary"></i>&nbsp;
        {{ textAddress || 'None on records'}}
    </dd>
    <dd class="col-xl-8" v-if='!hasAddress(this.entity)'>
      <i class="fas fa-address-card text-secondary"></i>&nbsp;
      None on records
    </dd>    
    <dt class="col-xl-4">Phone number</dt>
    <dd class="col-xl-8" v-if="hasAddress(this.entity)">
      <i class="fas fa-phone text-secondary"></i>&nbsp;
      <a :href="`tel:${this.phoneNumber}`"
        class="text-info" v-if="phoneNumber">{{ phoneNumber }}</a>
    </dd>
    <dd class="col-xl-8" v-if="!hasAddress(this.entity)">
      <i class="fas fa-phone text-secondary"></i>&nbsp; 
      None on records
    </dd>
    <dt class="col-xl-4">Email</dt>
    <dd class="colą-xl-8" v-if="hasAddress(this.entity)">
      <i class="fas fa-envelope text-secondary"></i>&nbsp;
      <a href="`mailto:${emailAddress}`"
        class="text-primary" v-if="emailAddress">{{ emailAddress }}</a>
    </dd>
    <dd class="col-xl-8" v-if="!hasAddress(this.entity)">
      <i class="fas fa-envelope text-secondary"></i>&nbsp; 
      None on records
    </dd>
  </dl>
</template>
<script>
import shared from '../../mixins/shared'
export default {
  mixins: [shared],
  props: ['medicoLegalCase', 'entity'],
  computed: {
    phoneNumber() {
      return this.medicoLegalCase[this.entity].addresses[0].phone_number
    },
    emailAddress() {
      return this.medicoLegalCase[this.entity].addresses[0].email
    },
    textAddress() {
      return this.medicoLegalCase[this.entity].addresses[0].address
    }
  }
}
</script>