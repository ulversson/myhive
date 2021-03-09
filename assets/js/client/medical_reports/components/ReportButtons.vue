<template>
	<div class='buttons' style="float: right;">
		<a class="btn btn-sm btn-myhive pull-right mt-5 mr-2"
      style="margin-bottom: 20px !important;"
			:disabled="isButtonDisabled"
      @click="save()">
      <i class="far fa-save"></i>&nbsp;Save
    </a>
    <a class="btn btn-sm btn-myhive pull-right mt-5 mr-2"
      style="margin-bottom: 20px !important;"
      :disabled="isButtonDisabled"
      @click="saveDraft()">
      <i class="far fa-save"></i>&nbsp;Save draft
    </a> 
    <a class="btn btn-sm btn-warning pull-right mt-5 mr-2"
      style="margin-bottom: 20px !important;"
      :disabled="isButtonDisabled"
      @click="preview()">
      <i class="fal fa-eye"></i>&nbsp;Preview
    </a> 
     <a class="btn btn-sm btn-danger pull-right mt-5 mr-2"
      style="margin-bottom: 20px !important;"
      :style="isButtonDisabled ? 'opacity: 0.5' : ''"
      :disabled="isButtonDisabled"
      @click="reset()">
      <i class="fal fa-eraser"></i>&nbsp;Reset
    </a>
    <a class="btn btn-sm btn-secondary pull-right mt-5 mr-0"
      style="margin-bottom: 20px !important;"
      @click="hideModal()">
      <i class="far fa-times-circle"></i>&nbsp;Close
    </a>
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
    hasErrors() {
      return this.$parent.hasErrors()
    },
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
    reset() {
      this.$swal({
        title: 'Reset this form?',
        message: "All fields will be cleared",
        showCancelButton: true,
        confirmButtonText: `Reset`,
      }).then((result) => {
        debugger
        if (result.isConfirmed) {
          this.$parent.reset()
        }
      })
    },
    openHistory() {
      $("a.nav-link.history").click()
    },
		save() {
      this.$parent.submit = true
      if (this.hasErrors) return;
      this.loading = true
      this.$parent.saveSections(true).then((res) => {
        this.loading = false
        this.history.loadUserReports(this.history.loadReportsUrl)
        this.openHistory()
        this.$parent.reset()
        this.$root.$emit('setUpdatedDate', res.updated_at)
      }).catch((err) => {
        this.$parent.submit = true
        this.loading = false
      })
    },
		preview() {
      this.$parent.submit = true
      if (this.hasErrors) return;
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
              this.$parent.submit = true
          })

        } else  {
          this.$parent.submit = true
          this.$swal(
            'Changes are not saved. Cannot preview document', 
            '', 
            'info'
          )
        }
      })
		},
		saveDraft() {
      this.$parent.submit = true;
      if (this.hasErrors) return;
      this.$parent.saveSections(false)
        .then(res => {
          this.openHistory()
          this.$swal('Changes saved.', 
            'You can view them on history tab', 
            'info'
          )
          this.$parent.$parent.$parent
            .$refs.history.loadUserReports(this.history.loadReportsUrl)
          this.$root.$emit('setUpdatedDate', res.updated_at)
        }).catch((err) => {
          this.loading = false
        })
		},
		hideModal() {
      debugger
      this.$parent.clearAutosave()
			this.$modal.hide("new-report")
		}
	}
}
</script>
