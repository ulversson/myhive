<template>
  <div class="nav-tabs-horizontal">
    <ul class="nav nav-tabs mb-4" role="tablist">
      <li class="nav-item">
        <a class="nav-link active"
          href="javascript: void(0);"
          data-toggle="tab"
          :data-target="`#details-${consultation.id}`"
          role="tab">
          <i class="fa fa-info-circle" aria-hidden="true"></i>
          Details
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link"
          href="javascript: void(0);"
          data-toggle="tab"
          :data-target="`#photo-${consultation.id}-photo-id`"
          role="tab">
          <i class="fas fa-id-card"></i>
          Photo ID
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link"
          href="javascript: void(0);"
          data-toggle="tab"
          :data-target="`#files-${consultation.id}`"
          role="tab">
          <i class="far fa-copy"></i>
          File assets
        </a>
      </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active" 
        :id="`details-${consultation.id}`">
        <ConsultationDetails :consultation="consultation"/>
        <div class='buttons' style='float: right'>
          <button class="btn btn-icon btn-xs btn-rounded btn-outline-warning mt-2 ml-2 pull-right"
            @click="editConsultation()">
            <i class="fas fa-edit"></i>
          </button>
          <button class="btn btn-icon btn-xs btn-rounded btn-outline-danger mt-2 ml-2 pull-right"
            @click="removeConsultation()">
            <i class="fas fa-trash-alt"></i>
          </button>
        </div>
      </div>
      <div class="tab-pane" :id="`photo-${consultation.id}-photo-id`">
        <PhotoId :consultation="consultation" />
      </div>
      <div class="tab-pane" :id="`files-${consultation.id}`">
       
      </div>
    </div>
  </div>
</template>
<script>
import ConsultationDetails from "./ConsultationDetails.vue"
import PhotoId from './PhotoId.vue'
export default {
  components: { ConsultationDetails, PhotoId },
  props: ["consultation"],
  methods: {
    removeConsultation() {
    let vue = this;
      UI.runConfirmedAction(
        'fas fa-trash-alt', 
        'DELETE',
        'Remove this consultation entry',
        'All data will be irreversibly deleted',
        `/api/v1/patient_consultation/${this.consultation.id}`, 
        () => {
          let mainConsultation = this.$parent.$parent.$parent
          mainConsultation.loadConsultations()
        }, () => {}, vue)
    },
    editConsultation() {
      this.$root.$emit('toggleConsultation', true)
      this.$root.$emit('consultation', this.consultation)
    }
  }
};
</script>
