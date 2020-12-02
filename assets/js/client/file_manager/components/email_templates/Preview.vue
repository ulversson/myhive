<template>
  <modal name="generated-email"
    :before-open="beforeOpen"
    height="auto"
    :width="'60%'"
    :adaptive="true"
    :scrollable="true">
    <div class='card'>
      <div class='card-header'>
        Email preview
      </div>
      <div class='card-body'>
        <div class='email p-3 m-3' v-html="email" >
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
  props: ['email'],
  methods: {
    beforeOpen(event) {
      if (event && event.params && event.params.email) {
        this.email = event.params.email
      }
    },
    hideWindow() {
      this.$modal.hide('generated-email')
    }
  }
}
</script>