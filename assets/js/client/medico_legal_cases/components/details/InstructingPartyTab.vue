<template>
  <div class="card" style='margin-bottom: 0'>
    <div class="card-body">
      <h5 class="mb-3 text-default">
        <strong>
          <i class='fa fa-2x icmn-office'></i>
          &nbsp;{{this.medicoLegalCase.instructing_party.name}}
        </strong>   
      </h5>
      <dl class="row">
        <dt class="col-xl-4">Address</dt>
        <dd class="col-xl-8" v-if="hasAddress('instructing_party')">
          <i class="fas fa-address-card text-secondary"></i>&nbsp;
          {{ textAddress }}
        </dd>
         <dd class="col-xl-8" v-if="!hasAddress('instructing_party')">
          <i class="fas fa-address-card text-secondary"></i>&nbsp;
          None on records
        </dd>
        <dt class="col-xl-4">Phone number</dt>
        <dd class="col-xl-8" v-if="hasAddress('instructing_party')">
          <i class="fas fa-phone text-secondary"></i>&nbsp;
          <a :href='`tel:${phoneNumber}`' 
            class='text-info' v-if='phoneNumber'>
            {{ phoneNumber}}
          </a>
        </dd>
        <dd class="col-xl-8" v-if="!hasAddress('instructing_party')">
          <i class="fas fa-phone text-secondary"></i>&nbsp;
          None on records
        </dd>
        <dt class="col-xl-4">Email</dt>
        <dd class="col-xl-8" v-if="hasAddress('instructing_party')">
          <i class="fas fa-envelope text-secondary"></i>&nbsp;
          <a :href='`mailto:${emailAddress}`' class='text-primary'
              v-if='emailAddress'>{{ emailAddress }}</a>
        </dd>
         <dd class="col-xl-8" v-if="!hasAddress('instructing_party')">
          <i class="fas fa-envelope text-secondary"></i>&nbsp;
          None on records
        </dd>
      </dl>   
    </div>
  </div>
</template>
<script>
import shared from '../../mixins/shared'
import globals from '../../mixins/globals'
export default {
  mixins: [shared, globals],
  props: ['medicoLegalCase'],
  computed: {
    phoneNumber() {
      return this.medicoLegalCase.instructing_party.addresses[0].phone_number
    },
    emailAddress() {
      return this.medicoLegalCase.instructing_party.addresses[0].email
    },
    textAddress() {
      return this.medicoLegalCase.instructing_party.addresses[0].address
    }
  }
}
</script>