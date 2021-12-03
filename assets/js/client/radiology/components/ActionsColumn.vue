<template>
  <div class='radiology-actions' style='font-size: 13px'>
    <a class="btn btn-icon btn-my-hive mr-2 mb-2"
      :href="`weasis://${viewStudyLink}`">
      <i class="far fa-eye"></i>
    </a>
  </div>
</template>
<script>
export default {
  props: ['row', 'data'],
  computed: {
    viewStudyLink() {
      const studyId = this.data['Study Instance UID']
      return encodeURIComponent(`$dicom:rs --url "${this.browserLink}" -r "studyUID=${studyId}" -H "Authorization: Basic ZGljb21hZG1pbjozNDVkYWFjZDhiZTM="`)
    },
    browserLink() {
      return "https://dicom.my-hive.co.uk/orthanc/dicom-web" 
    }
  }
}
</script>