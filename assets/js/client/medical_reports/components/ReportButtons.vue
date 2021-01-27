<template>
	<div class='buttons'>
		<a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
      style="float: right;margin-bottom: 20px !important;"
      @click="hideModal()">
      <i class="far fa-times-circle"></i>&nbsp;Close
    </a>
		&nbsp;
		<button class="btn btn-sm btn-warning pull-right mt-2 mr-3"
      style="float: right;margin-bottom: 20px !important;"
			:disabled="isButtonDisabled"
      @click="preview()">
      <i class="fal fa-eye"></i>&nbsp;Preview
    </button>	
		&nbsp;
		<button class="btn btn-sm btn-myhive pull-right mt-2 mr-3"
      style="float: right;margin-bottom: 20px !important;"
			:disabled="isButtonDisabled"
      @click="saveDraft()">
      <i class="far fa-save"></i>&nbsp;Save draft
    </button>	
		&nbsp;
		<button class="btn btn-sm btn-myhive pull-right mt-2 mr-3"
      style="float: right;margin-bottom: 20px !important;"
			:disabled="isButtonDisabled"
      @click="save()">
      <i class="far fa-save"></i>&nbsp;Save
    </button>
    <div class="vld-parent">
      <loading :active.sync="loading" 
        :can-cancel="false" 
        :is-full-page="fullPage">  
      </loading>
    </div>	
  </div>
</template>
<script>
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.css';
export default {
	props: ['isButtonDisabled'],
  data() {
    return {
      loading: false,
      fullPage: true
    }
  },
  components: { Loading },
  computed: {
    history() {
      return this.$parent.$parent.$parent.$refs.history
    },
    previewReportModal()  {
      return this.$root.$children[0]
        .$refs.headerPanel
        .$refs.caseActions
        .$refs.previewReport
    }
  },
	methods: {
    openHistory() {
      $("a.nav-link.history").click()
    },
		save() {
      this.loading = true
			this.$parent.saveSections(true).then((res) => {
        this.loading = false
        this.history.loadUserReports(this.history.loadReportsUrl)
        this.openHistory()
      })
		},
		preview() {
      this.$swal({
        title: 'Previewing will save changes',
        message: "Preview will open on new tab",
        showCancelButton: true,
        confirmButtonText: `Save`,
      }).then((result) => {
        if (result.isConfirmed) {
          this.$parent.saveSections(false)
            .then((report) => {
              window.open(`${window.location.origin}/report/${report.id}`, "_blank")
          })

        } else  {
          this.$swal(
            'Changes are not saved. Cannot preview document', 
            '', 
            'info'
          )
        }
      })
		},
		saveDraft() {
      this.$parent.saveSections(false)
        .then(res => {
          this.openHistory()
          this.$swal('Changes saved.', 
            'You can view them on history tab', 
            'info'
          )
          this.$parent.$parent.$parent
            .$refs.history.loadUserReports(this.history.loadReportsUrl)
        })
		},
		hideModal() {
			this.$modal.hide("new-report")
		}
	}
}
</script>
