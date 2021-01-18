<template>
  <div class="card">
    <div class="card-header" role="tab" id="consultations">
      <a data-toggle="collapse" data-parent="#consultations" href="#" aria-expanded="true"
        :aria-controls="`cons-consultation.id`"
        class="toggle-cons"
        @click="collapse(consultation.id)">
        <h5 class="mb-0">
          {{order}}. {{consultationFormattedDate}} 
          <i class="fas fa-angle-down rotate-icon" 
            v-if="!this.collapsed"></i>
          <i class="fas fa-angle-up rotate-icon" 
            v-if="this.collapsed"></i>
        </h5>
      </a>
    </div>
    <div :id="`cons-${consultation.id}`" class='collapse' 
      role="tabpanel" aria-labelledby="headingOne1" data-parent="#consultations"
      style="font-size: 16px !important">
      <div class="card-body card-with-shadow" style="min-height: 90vh">
          <h5 class="mb-3 text-default">
            <strong><i class="fa fa-2x fa-user-md" 
            aria-hidden="true"></i>
            System ID&nbsp;{{consultation.id}}
            </strong>
          </h5> 
          <ConsultationTab :consultation="consultation" />
        </div>
    </div>
  </div>
</template>
<script>
import ConsultationTab from './ConsultationTab.vue'
export default {
  components: { ConsultationTab },
  props: ['consultation', 'order'],
  computed: {
    consultationFormattedDate() {
      return moment(this.consultation.consultation_date).format('DD/MM/YYYY HH:MM')
    }
  },
  data() {
    return {
      collapsed: true
    }
  },
  methods: {
    collapse(id) {
      $(`#cons-${id}`).collapse('toggle')
      $("[data-toggle='tooltip']").tooltip()
      this.collapsed = !this.collapsed
    }
  }
}

</script>