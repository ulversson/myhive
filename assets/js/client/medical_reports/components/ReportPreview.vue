<template>
  <modal name="generated-report"
    :before-open="beforeOpen"
    height="auto"
    :width="'70%'"
    :adaptive="true"
    :scrollable="true">
    <div class='card'>
      <div class='card-header'>
        Report preview
      </div>
      <div class='card-body'>
        <div v-html="reportHtml" 
          style="max-height: 600px; overflow-y: scroll !important" >
        </div>
        <div class='card-footer'>
          <a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
            style="float: right; margin-right: 0px !important;margin-bottom: 20px !important;"
            @click="hideWindow()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
        </div>
      </div>
    </div>
  </modal>
</template>
<script>
export default {
  props: ['reportHtml'],
  methods: {
    beforeOpen(event) {

    },
    hideWindow() {
      this.$root.$emit('previewReport', '')
      this.$modal.hide('generated-report')
    }
  }
}
</script>